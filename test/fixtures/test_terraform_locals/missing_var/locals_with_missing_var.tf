# This local references a variable that doesn't exist
# Should result in a placeholder value with warning
locals {
  with_missing_var = var.nonexistent_variable
  valid_local = "this_works"
}

resource "terraform_data" "example" {
  input = {
    value   = local.valid_local
    missing = local.with_missing_var
  }
}

