locals {
  app_name = "first_name"
  app_version = "1.0.0"
}

resource "terraform_data" "override_a" {
  name = local.app_name
  version = local.app_version
}

