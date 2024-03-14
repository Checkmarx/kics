resource "aws_api_gateway_stage" "postive1" {
  stage_name    = "dev"
  rest_api_id   = "id"
}

resource "aws_api_gateway_method_settings" "all" {
  stage_name  = aws_api_gateway_stage.postive1.stage_name
  method_path = "*/*"

  settings {
    logging_level   = "ERROR"
  }
}

resource "aws_apigatewayv2_stage" "postive2" {
  stage_name    = "dev"
  rest_api_id   = "id"

  default_route_settings {
    logging_level   = "ERROR"
  }
}
