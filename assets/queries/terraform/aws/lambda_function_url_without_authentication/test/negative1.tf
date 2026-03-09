resource "aws_lambda_function_url" "negative1" {
  function_name      = aws_lambda_function.example.function_name
  authorization_type = "AWS_IAM"
}
