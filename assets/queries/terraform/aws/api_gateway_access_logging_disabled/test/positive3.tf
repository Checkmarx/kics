resource "aws_api_gateway_stage" "positive30" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }
}

resource "aws_api_gateway_method_settings" "allpositive3" {
  stage_name  = aws_api_gateway_stage.positive30.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
  }
}

resource "aws_apigatewayv2_stage" "positive31" {
  stage_name    = "dev"
  rest_api_id   = "id"

  access_log_settings {
    destination_arn = "dest"
  }

  default_route_settings {
    data_trace_enabled = "true"
  }
}
