# This creates a duplicate local which should cause an error
locals {
  duplicate_name = "from_file2"
  unique_to_file2 = "value2"
}

resource "terraform_data" "from_file2" {
  input = local.duplicate_name
}

