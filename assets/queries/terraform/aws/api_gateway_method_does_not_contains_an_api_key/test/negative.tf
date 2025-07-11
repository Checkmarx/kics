resource "aws_api_gateway_method" "negative1" {
  rest_api_id       = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id       = aws_api_gateway_resource.MyDemoResource.id
  http_method       = "GET"
  authorization     = "NONE"
  api_key_required  = true
}

resource "aws_api_gateway_method" "negative2" {
  rest_api_id       = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id       = aws_api_gateway_resource.MyDemoResource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  api_key_required = false
}
