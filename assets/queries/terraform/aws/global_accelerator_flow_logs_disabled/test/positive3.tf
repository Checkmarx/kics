resource "aws_globalaccelerator_accelerator" "positive3" {
  name            = "Example"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled   = false
  }
}
