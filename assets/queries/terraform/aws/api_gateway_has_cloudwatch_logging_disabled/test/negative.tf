resource "aws_api_gateway_stage" "logging_enabled" {
  stage_name = "logging_enabled"
  # ... other configuration ...

  access_log_settings {
      destination_arn = "some-arn"
      format = "JSON"
  }
}