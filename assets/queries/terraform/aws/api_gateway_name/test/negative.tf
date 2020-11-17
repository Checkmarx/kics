resource "aws_api_gateway_stage" "example" {
  depends_on = [aws_cloudwatch_log_group.example]

  stage_name = "prod"
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "prod"
}

resource "aws_cloudwatch_log_group" "example2" {
  name              = "Xpto"
}