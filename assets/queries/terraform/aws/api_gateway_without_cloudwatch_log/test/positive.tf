resource "aws_api_gateway_stage" "example" {
  depends_on = [aws_cloudwatch_log_group.example2]

  stage_name = "example"
}

resource "aws_cloudwatch_log_group" "example2" {
  name              = "Xpto"
}
