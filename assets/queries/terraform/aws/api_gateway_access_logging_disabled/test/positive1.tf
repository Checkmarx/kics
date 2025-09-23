resource "aws_api_gateway_stage" "positive10" {
  stage_name    = "dev"
  rest_api_id   = "id"
}

resource "aws_api_gateway_method_settings" "allpositive1" {
  stage_name  = aws_api_gateway_stage.positive10.stage_name
  method_path = "*/*"

  settings {
    logging_level   = "ERROR"
  }
}

resource "aws_apigatewayv2_stage" "positive11" {
  stage_name    = "dev"
  rest_api_id   = "id"

  default_route_settings {
    logging_level   = "ERROR"
  }
}
