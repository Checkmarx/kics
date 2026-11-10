resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers    = { redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body)) }
  lifecycle { create_before_destroy = true }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "v1"
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.access.arn
    format          = jsonencode({ requestId = "$context.requestId" })
  }
}
