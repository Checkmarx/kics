# HCL policy document, sub only checked with the Null operator (not an allow-list)
data "aws_iam_policy_document" "positive29" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "Null"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["false"]
    }
  }
}
