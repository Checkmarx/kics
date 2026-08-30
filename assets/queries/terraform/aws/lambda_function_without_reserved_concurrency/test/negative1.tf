resource "aws_lambda_function" "pass" {
  function_name                  = "my_function"
  runtime                        = "python3.11"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "index.handler"
  reserved_concurrent_executions = 10
}
