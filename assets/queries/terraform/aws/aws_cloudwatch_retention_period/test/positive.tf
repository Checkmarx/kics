resource "aws_cloudwatch_log_group" "yada" {
  name = "Yada"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }
}



resource "aws_cloudwatch_log_group" "yada2" {
  name = "Yada"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }

  retention_in_days = 0
}