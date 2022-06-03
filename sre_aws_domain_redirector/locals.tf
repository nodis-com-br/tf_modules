locals {
  domain_name = var.domains[0]
  subject_alternative_names = [for d in var.domains : d if index(var.domains, d) != 0]
}