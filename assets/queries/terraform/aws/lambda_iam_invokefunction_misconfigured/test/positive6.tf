resource "aws_iam_policy" "positive6policy" {
  name        = "positive6policy"
  path        = "/"
  description = "positive6 Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2022-20-27"
    Statement = [
      {
        Action = [
          "lambda:*",
        ]
        Effect   = "Allow"
        Resource = [
            "arn:aws:lambda:*:*:function:*:*"
        ]
      },
    ]
  })
}
