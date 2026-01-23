# This file overrides app_name from override_locals_a.tf
locals {
  app_name = "overridden_name"
}

resource "terraform_data" "override_b" {
  input = local.app_name
}

