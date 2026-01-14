# This file overrides app_name from override_locals_a.tf
locals {
  app_name = "overridden_name"
}

resource "test" "override_b" {
  name = local.app_name
}

