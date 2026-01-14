locals {
  full_name = "${local.base_name}-service"
  full_port = local.base_port
}

resource "test" "b" {
  name = local.full_name
  port = local.full_port
}

