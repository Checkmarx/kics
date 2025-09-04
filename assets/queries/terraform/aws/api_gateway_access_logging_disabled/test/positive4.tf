resource "aws_api_gateway_stage" "positive40" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }
}

resource "aws_api_gateway_method_settings" "allpositive4" {
  stage_name  = aws_api_gateway_stage.positive40.stage_name
  method_path = "*/*"
}

resource "aws_apigatewayv2_stage" "positive41" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }
}
