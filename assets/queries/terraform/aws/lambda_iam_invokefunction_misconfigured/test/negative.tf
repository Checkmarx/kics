resource "aws_iam_policy" "negativepolicy" {
  name        = "negativepolicy"
  path        = "/"
  description = "Negative Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
        ]
        Effect   = "Allow"
        Resource = [
            "arn:aws:lambda:*:*:function:negative",
            "arn:aws:lambda:*:*:function:negative:*"
        ]
      },
    ]
  })
}
