resource "aws_globalaccelerator_accelerator" "positive1" {
  name            = "Example"
  ip_address_type = "IPV4"
  enabled         = true
}
