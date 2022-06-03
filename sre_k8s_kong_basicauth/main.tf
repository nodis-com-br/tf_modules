module "plugin" {
  source = "../helm_release"
  name = var.name
  namespace = var.namespace
  chart = var.plugin_chart
  chart_version = var.plugin_chart_version
  repository = var.charts_repository
  values = [
    jsonencode({annotations = {"kubernetes.io/ingress.class" = var.ingress_class}}),
    jsonencode({plugin: "basic-auth"})
  ]
  providers = {
    helm = helm
  }
}

module "password_bot" {
  source = "../sre_k8s_vault_bot"
  name = "${var.name}-password-bot"
  namespace = var.namespace
  vault_auth_backend = var.vault_auth_backend
  vault_policies = ["path \"${var.consumers_secret_path}\" {capabilities = [\"read\"]}"]
  chart_values = [
    jsonencode({
      execute_secrets_file = true
      node_selector = {nodePoolClass = "general"}
      envs = {SECRETS_FILE = "/vault/secrets/update-script"}
      serviceaccount = {
        enabled = true
        bindings = [{kind = "Role"}]
        roles = [{rules = [
          {apiGroups = [""], resources = ["secrets"], verbs = ["*"]},
          {apiGroups = ["configuration.konghq.com"], resources = ["kongconsumers"], verbs = ["*"]},
        ]}]
      }
      pod = {
        annotations = {
          "vault.hashicorp.com/agent-inject-secret-update-script" = var.consumers_secret_path
          "vault.hashicorp.com/agent-inject-perms-update-script" = "0755"
          "vault.hashicorp.com/agent-inject-template-update-script" = <<-EOF
            #!/bin/bash
            set -e
            UNDESIRED_CONSUMERS=($(kubectl get kongconsumer --no-headers -o custom-columns=":metadata.name"))
            {{- with secret "${var.consumers_secret_path}" }}
            {{- range $username, $password := .Data.data }}

            if ! kubectl get kongconsumer "${var.name}-{{ $username }}" > /dev/null 2>&1; then
              echo -n "
              apiVersion: configuration.konghq.com/v1
              kind: KongConsumer
              metadata:
                annotations:
                  kubernetes.io/ingress.class: ${var.ingress_class}
                name: ${var.name}-{{ $username }}
                namespace: pypicloud
              credentials:
                - ${var.name}-{{ $username }}
              username: {{ $username }}" | kubectl apply -f -
            fi

            if [[ $(kubectl get secret "${var.name}-{{ $username }}" -o json 2> /dev/null | jq -r .data.password) != "{{ base64Encode $password }}" ]]; then
              echo -n "
              apiVersion: v1
              kind: Secret
              metadata:
                name: ${var.name}-{{ $username }}
                namespace: ${var.namespace}
              type: Opaque
              data:
                username: {{ base64Encode $username }}
                password: {{ base64Encode $password }}
                kongCredType: {{ base64Encode "basic-auth" }}" | kubectl apply -f -
            fi

            UNDESIRED_CONSUMERS=($${UNDESIRED_CONSUMERS[@]/${var.name}-{{ $username }}/})
            {{- end }}
            {{- end }}

            for UNDESIRED in "$${UNDESIRED_CONSUMERS[@]}"; do
              kubectl delete kongconsumer "$${UNDESIRED}"
              kubectl delete secret "$${UNDESIRED}"
            done
          EOF
        }
      }
    })
  ]
  providers = {
    helm = helm
  }
}