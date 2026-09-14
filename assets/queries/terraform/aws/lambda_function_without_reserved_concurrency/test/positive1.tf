resource "aws_lambda_function" "fail" {
  function_name = "my_function"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
}
