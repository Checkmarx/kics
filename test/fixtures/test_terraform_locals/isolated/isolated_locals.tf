locals {
  isolated_value = "isolated"
}

resource "test" "isolated" {
  value = local.isolated_value
}

