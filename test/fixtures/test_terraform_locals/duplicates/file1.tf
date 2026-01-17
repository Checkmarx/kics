locals {
  duplicate_name = "from_file1"
  unique_to_file1 = "value1"
}

resource "terraform_data" "from_file1" {
  input = local.duplicate_name
}

