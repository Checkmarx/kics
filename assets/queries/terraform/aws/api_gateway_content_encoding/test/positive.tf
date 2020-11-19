resource "aws_api_gateway_rest_api" "example1" {
  name = "regional-example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_rest_api" "example2" {
  name = "regional-example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  minimum_compression_size = -1
}


resource "aws_api_gateway_rest_api" "example3" {
  name = "regional-example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  minimum_compression_size = 10485760
}