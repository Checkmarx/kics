resource "aws_lambda_function_url" "positive1" {
  function_name      = aws_lambda_function.example.function_name
  authorization_type = "NONE"
}
