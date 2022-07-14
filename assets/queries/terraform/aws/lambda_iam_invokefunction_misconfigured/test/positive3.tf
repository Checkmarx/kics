resource "aws_iam_policy" "positive3policy" {
  name        = "positive3policy"
  path        = "/"
  description = "positive3 Policy"

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
            "arn:aws:lambda:*:*:function:*:*"
        ]
      },
    ]
  })
}
