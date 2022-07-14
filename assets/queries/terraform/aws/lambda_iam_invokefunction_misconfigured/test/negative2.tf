resource "aws_iam_policy" "negative2policy" {
  name        = "negative2policy"
  path        = "/"
  description = "negative2 Policy"

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
        Resource = ["*"]
      },
    ]
  })
}
