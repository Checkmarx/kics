resource "aws_api_gateway_stage" "positive20" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }
}

resource "aws_api_gateway_method_settings" "allpositive2" {
  stage_name  = aws_api_gateway_stage.positive20.stage_name
  method_path = "*/*"

  settings {
    logging_level   = ""
  }
}

resource "aws_apigatewayv2_stage" "positive21" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }

  default_route_settings {
    logging_level   = ""
  }
}
