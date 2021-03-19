resource "aws_apigatewayv2_stage" "negative1" {
  api_id = aws_apigatewayv2_api.example.id
  name   = "example-stage"
  description = "example description"
  auto_deploy = true
  access_log_settings = {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode(
      {
        httpMethod     = "$context.httpMethod"
        ip             = "$context.identity.sourceIp"
        protocol       = "$context.protocol"
        requestId      = "$context.requestId"
        requestTime    = "$context.requestTime"
        responseLength = "$context.responseLength"
        routeKey       = "$context.routeKey"
        status         = "$context.status"
      }
    )
  }
}
