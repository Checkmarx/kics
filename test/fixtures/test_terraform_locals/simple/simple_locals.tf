variable "prefix" {
  type    = string
  default = "prod"
}

locals {
  simple_string = "hello"
  simple_number = 42
  simple_bool   = true
}

resource "test" "example" {
  name   = local.simple_string
  count  = local.simple_number
  active = local.simple_bool
}

