resource "aws_iam_policy" "negative1policy" {
  name        = "negative1policy"
  path        = "/"
  description = "negative1 Policy"

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
            "arn:aws:lambda:*:*:function:negative1",
            "arn:aws:lambda:*:*:function:negative1:*"
        ]
      },
    ]
  })
}
