# This is a separate module (subdirectory)
# It should NOT have access to parent's locals
locals {
  child_value = "child"
  shared_name = "from_child"
}

resource "terraform_data" "child" {
  input = local.child_value
  # This would fail if parent_value is not accessible (which is correct)
  # parent_ref = local.parent_value
}

