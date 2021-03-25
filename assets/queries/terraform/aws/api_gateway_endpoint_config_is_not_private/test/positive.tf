resource "aws_api_gateway_rest_api" "positive1" {
  name = "regional-example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
