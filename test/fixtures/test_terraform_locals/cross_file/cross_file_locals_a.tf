locals {
  base_name = "myapp"
  base_port = 8080
}

resource "terraform_data" "a" {
  name = local.base_name
  port = local.base_port
}

