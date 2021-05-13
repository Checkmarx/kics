resource "aws_globalaccelerator_accelerator" "positive1" {
  name            = "Example"
  ip_address_type = "IPV4"
  enabled         = true
}

resource "aws_globalaccelerator_accelerator" "positive2" {
  name            = "Example"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_s3_bucket = "example-bucket"
    flow_logs_s3_prefix = "flow-logs/"
  }
}

resource "aws_globalaccelerator_accelerator" "positive3" {
  name            = "Example"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled   = false
  }
}
