resource "aws_api_gateway_rest_api" "negative1" {
  name = "regional-example"

  endpoint_configuration {
    types = ["PRIVATE"]
  }
}
