resource "aws_api_gateway_rest_api" "test" {
  name = "example-rest-api"
}

resource "aws_api_gateway_rest_api_policy" "test" {
  rest_api_id = aws_api_gateway_rest_api.test.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::123456789012:user/test-user"
        ]
      },
      "Action": "execute-api:Invoke",
      "Resource": "aws_api_gateway_rest_api.test.execution_arn",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "123.123.123.123/32"
        }
      }
    }
  ]
}
EOF
}
