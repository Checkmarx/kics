resource "aws_apigatewayv2_api" "pass" {
  name          = "my-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["https://app.example.com"]
    allow_methods = ["GET", "POST"]
  }
}
