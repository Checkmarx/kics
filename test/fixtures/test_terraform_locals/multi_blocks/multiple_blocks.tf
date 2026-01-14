# Multiple locals blocks in the same file
locals {
  first_local = "first"
}

locals {
  second_local = "second"
}

locals {
  third_local = "third"
  # Reference to earlier local
  combined = "${local.first_local}-${local.second_local}"
}

resource "test" "multi_blocks" {
  first  = local.first_local
  second = local.second_local
  third  = local.third_local
  combo  = local.combined
}

