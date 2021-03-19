resource "aws_apigatewayv2_stage" "positive1" {
  api_id = aws_apigatewayv2_api.example.id
  name   = "example-stage-positive"
  description = "example description"
  auto_deploy = true
}
