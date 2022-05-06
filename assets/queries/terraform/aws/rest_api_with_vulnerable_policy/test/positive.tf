provider "aws" {
  region = "us-east-1"
}

resource "aws_api_gateway_rest_api" "api_gw" {
  name        = "api-gw-cache-encrypted"
  description = "API GW test"
}



resource "aws_api_gateway_rest_api_policy" "test" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "execute-api:*",
      "Resource": "${aws_api_gateway_rest_api.api_gw.arn}"
    }
  ]
}
EOF
}


resource "aws_api_gateway_deployment" "api_gw_deploy" {
  depends_on  = [aws_api_gateway_integration.api_gw_int]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name  = "dev"
}

resource "aws_api_gateway_resource" "api_gw_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = "mytestresource"
}

resource "aws_api_gateway_method" "api_gw_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  resource_id   = aws_api_gateway_resource.api_gw_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_gw_int" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  resource_id = aws_api_gateway_resource.api_gw_resource.id
  http_method = aws_api_gateway_method.api_gw_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/xml" = <<EOF
{
   "body" : $input.json('$')
}
EOF
  }
}

resource "aws_api_gateway_stage" "api_gw_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  deployment_id = aws_api_gateway_deployment.api_gw_deploy.id
}

resource "aws_api_gateway_method_settings" "api_gw_method_sett" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name  = aws_api_gateway_stage.api_gw_stage.stage_name
  method_path = "${aws_api_gateway_resource.api_gw_resource.path_part}/${aws_api_gateway_method.api_gw_method.http_method}"

  settings {
    logging_level        = "OFF"
    caching_enabled      = true # This is required for cache encryption
    cache_data_encrypted = true # This is required for cache encryption
  }
}
