resource "aws_api_gateway_method" "positive1" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "GET"
  authorization = "NONE"
  authorizer_id = aws_api_gateway_authorizer.this.id

  request_parameters = {
    "method.request.path.proxy" = true
  }
}
