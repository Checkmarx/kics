resource "aws_lambda_function" "negative1" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "exports.test"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  runtime = "nodejs12.x"

  tags = {
    Name = "lambda"
  }

  environment = {
    variables = {
      foo = "bar"
    }
  }
}
