# HCL policy document, condition only on aud, no sub
data "aws_iam_policy_document" "positive9" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "gitlab.example.com:aud"
      values   = ["https://gitlab.example.com"]
    }
  }
}
