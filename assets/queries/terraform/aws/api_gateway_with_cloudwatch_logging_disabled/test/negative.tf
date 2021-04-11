resource "aws_api_gateway_stage" "negative1" {
  depends_on = [aws_cloudwatch_log_group.example]

  stage_name = "prod"
}

resource "aws_cloudwatch_log_group" "negative2" {
  name              = "prod"
}

resource "aws_cloudwatch_log_group" "negative3" {
  name              = "Xpto"
}