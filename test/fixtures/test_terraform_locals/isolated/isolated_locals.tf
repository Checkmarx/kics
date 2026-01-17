locals {
  isolated_value = "isolated"
}

resource "terraform_data" "isolated" {
  value = local.isolated_value
}

