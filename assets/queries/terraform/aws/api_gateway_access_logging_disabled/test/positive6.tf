resource "aws_api_gateway_stage" "positive60" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }
}

resource "aws_api_gateway_method_settings" "allpositive6" {
  stage_name  = aws_api_gateway_stage.positive60.stage_name
  method_path = "*/*"

  settings {
  }
}


resource "aws_apigatewayv2_stage" "positive61" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }

  default_route_settings {
  }
}
