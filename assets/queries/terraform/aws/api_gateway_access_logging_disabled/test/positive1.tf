resource "aws_api_gateway_stage" "postive1" {
  stage_name    = "dev"
  rest_api_id   = "id"
}

resource "aws_apigatewayv2_stage" "postive2" {
  stage_name    = "dev"
  rest_api_id   = "id"
}
