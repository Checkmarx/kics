data "aws_iam_policy_document" "negative6" {
  statement {
    sid     = "negative6"
    effect  = "Deny"
    actions = [
      "s3:GetObject",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "secretsmanager:GetSecretValue",
      "*",
      "s3:*",
    ]
    resources = ["*"]
  }
}