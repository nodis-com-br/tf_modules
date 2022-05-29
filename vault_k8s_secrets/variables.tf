variable "path" {}

variable "type" {
  default = "kubernetes"
}

variable "host" {}

variable "service_account_name" {
  default = "vault-secrets-backend"
}

variable "service_account_namespace" {
  default = "kube-system"
}

variable "service_account_ruleset" {
  type = list(object({
    api_groups = list(string)
    resources = list(string)
    verbs = list(string)
  }))
  default = [
    {
      api_groups = [""]
      resources = ["secrets", "serviceaccounts"]
      verbs = ["get", "list", "watch", "create", "update", "patch", "delete"]
    },
    {
      api_groups = ["rbac.authorization.k8s.io"]
      resources = ["roles", "clusterroles", "rolebindings", "clusterrolebindings"]
      verbs = ["*"]
    }
  ]
}


variable "admin_role" {
  default = "cluster-admin"
}

variable "editor_role" {
  default = "edit"
}

variable "viewer_role" {
  default = "view"
}

variable "default_ttl" {
  default = null
}

variable "max_ttl" {
  default = null
}