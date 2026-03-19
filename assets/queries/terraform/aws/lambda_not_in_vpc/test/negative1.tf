resource "aws_lambda_function" "pass" {
  function_name = "my_function"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  vpc_config {
    subnet_ids         = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.lambda.id]
  }
}
