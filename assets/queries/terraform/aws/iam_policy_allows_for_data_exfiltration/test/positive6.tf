data "aws_iam_policy_document" "positive6" {
  statement {
    sid     = "positive6"
    effect  = "Allow"
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

data "aws_iam_policy_document" "positive6_array" {
  statement {
    sid     = "positive6_array_1"
    effect  = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = ["*"]
  }
  statement {
    sid     = "positive6_array_2"
    effect  = "Allow"
    actions = [
      "*"
    ]
    resources = ["*"]
  }
}