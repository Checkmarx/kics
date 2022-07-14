resource "aws_iam_policy" "positive2policy" {
  name        = "positive2policy"
  path        = "/"
  description = "Positive2 Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2022-20-27"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
        ]
        Effect   = "Allow"
        Resource = [
            "arn:aws:lambda:*:*:function:positive2*:*"
        ]
      },
    ]
  })
}
