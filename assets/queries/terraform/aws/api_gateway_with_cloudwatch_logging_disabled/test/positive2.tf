resource "aws_api_gateway_rest_api" "apiLambda" {
    # ... other configuration ...
}

resource "aws_api_gateway_stage" "positive2" {
  depends_on         = [aws_api_gateway_deployment.api_http_method_deployment]
  stage_name         = "qa"
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.wrong_sample_name.arn
    # ...
  }
}

resource "aws_cloudwatch_log_group" "sample_name" {
  name = "/aws/api-gateway/apigw-name-app"
  retention_in_days = 14
  # ... potentially other configuration ...
}