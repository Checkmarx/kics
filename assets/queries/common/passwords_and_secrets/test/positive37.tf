# "Generic Secret" - 3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99  positive-test
resource "aws_lambda_function" "analysis_lambda2" {
  # lambda have plain text secrets in environment variables
  filename      = "resources/lambda_function_payload.zip"
  function_name = "${local.resource_prefix.value}-analysis"
  role          = "aws_iam_role.iam_for_lambda.arn"
  handler       = "exports.test"

  source_code_hash = "${filebase64sha256("resources/lambda_function_payload.zip")}"

  runtime = "nodejs12.x"

  environment {
    variables = {
      secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" # positive1
    }
  }
}
