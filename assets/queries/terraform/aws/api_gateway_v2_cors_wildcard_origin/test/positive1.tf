resource "aws_apigatewayv2_api" "fail" {
  name          = "my-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST"]
  }
}
