# Lambda function unrelated to S3: no aws_s3_bucket in the file, so there are no bucket notifications to enable
resource "aws_lambda_function" "lambda_init_mysql" {
  count         = var.enabled ? 1 : 0
  function_name = "init-mysql"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "python3.12"
  filename      = "lambda.zip"
}
