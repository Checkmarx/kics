resource "aws_cloudwatch_log_group" "yada3" {
  name = "Yada"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }

  retention_in_days = 1
}
