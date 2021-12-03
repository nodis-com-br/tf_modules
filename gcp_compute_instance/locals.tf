locals {
  policy_conditions = [
    var.instance_schedule_policy != null
  ]
}