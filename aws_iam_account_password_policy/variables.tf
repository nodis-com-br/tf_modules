
variable "minimum_password_length" {
  default = 14
}

variable "password_reuse_prevention" {
  default = 24
}

variable "max_password_age" {
  default = 90
}

variable "require_lowercase_characters" {
  default = true
}

variable "require_numbers" {
  default = true
}

variable "require_uppercase_characters" {
  default = true
}

variable "require_symbols" {
  default = true
}

variable "allow_users_to_change_password" {
  default = true
}


