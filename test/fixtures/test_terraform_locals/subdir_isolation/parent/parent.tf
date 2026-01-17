locals {
  parent_value = "parent"
  shared_name = "from_parent"
}

resource "terraform_data" "parent" {
  input = local.parent_value
}

