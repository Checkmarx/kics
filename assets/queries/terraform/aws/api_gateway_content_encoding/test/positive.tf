resource "aws_api_gateway_rest_api" "positive1" {
  name = "regional-example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_rest_api" "positive2" {
  name = "regional-example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  minimum_compression_size = -1
}


resource "aws_api_gateway_rest_api" "positive3" {
  name = "regional-example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  minimum_compression_size = 10485760
}