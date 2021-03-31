resource "aws_lambda_permission" "positive1" {
  action        = "lambda:DeleteFunction"
  function_name = aws_lambda_function.logging.function_name
  principal     = "logs.eu-west-1.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.default.arn}:*"
}
