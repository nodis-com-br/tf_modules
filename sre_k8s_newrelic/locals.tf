locals {
  rabbitmq_integration = jsonencode({
    newrelic-infrastructure = {integrations_config = {"nri-rabbitmq-%[1]s.yaml" = {
      name = "nri-rabbitmq-%[1]s.yaml"
      data = {
        discovery = {command = {
          exec = "/var/db/newrelic-infra/nri-discovery-kubernetes --namespaces rabbitmq"
          match = {"label.app.kubernetes.io/name" = "%[1]s" }
        }}
        integrations = [{
          name = "nri-rabbitmq"
          labels = {environment = "%[2]s"}
          env = {HOSTNAME = "$${discovery.ip}", USERNAME = "%[3]s", PASSWORD = "%[4]s"}
        }]
      }
    }
  }}})
}