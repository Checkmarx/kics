resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

module "lambda_with_incomplete_dlq" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 5.0"

  function_name = "lambdaWithIncompleteDLQ"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"
  filename      = "lambda.zip"
  
}