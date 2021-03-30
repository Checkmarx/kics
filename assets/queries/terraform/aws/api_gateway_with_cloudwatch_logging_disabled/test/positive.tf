resource "aws_api_gateway_stage" "positive1" {
  depends_on = [aws_cloudwatch_log_group.example2]

  stage_name = "example"
}

resource "aws_cloudwatch_log_group" "positive2" {
  name              = "Xpto"
}
