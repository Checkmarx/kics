resource "aws_api_gateway_stage" "positive70" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }
}
