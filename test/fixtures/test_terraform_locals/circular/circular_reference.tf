# This creates a circular dependency that should be handled gracefully
locals {
  circular_a = local.circular_b
  circular_b = local.circular_a
}

resource "test" "circular" {
  value_a = local.circular_a
  value_b = local.circular_b
}
