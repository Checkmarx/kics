resource "aws_api_gateway_stage" "positive50" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }
}

resource "aws_api_gateway_method_settings" "allpositive5" {
  stage_name  = aws_api_gateway_stage.positive50.stage_name
  method_path = "*/*"

  settings {
    logging_level   = "OFF"
  }
}

resource "aws_apigatewayv2_stage" "positive51" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }

  default_route_settings {
    logging_level   = "OFF"
  }
}
