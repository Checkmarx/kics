resource "aws_lambda_function" "negative3" {
  function_name = "negative3"
  role          = "negative3_role"
}

resource "aws_iam_policy" "negative3policy" {
  name        = "negative3policy"
  path        = "/"
  description = "negative3 Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = [
            aws_lambda_function.negative3.arn,
            "${aws_lambda_function.negative3.arn}:*"
        ]
      },
    ]
  })
}
