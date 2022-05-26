locals {
  roles = flatten([
    for sa in var.sa_mappings : [
      for policy in sa.policies : {
        service_account = sa.service_account
        namespace = sa.namespace
      }
    ]
  ])
  policy_attachments = flatten([
    for sa in var.sa_mappings : [
      for policy in sa.policies : {
        service_account = sa.service_account
        policy = policy
      }
    ]
  ])
}