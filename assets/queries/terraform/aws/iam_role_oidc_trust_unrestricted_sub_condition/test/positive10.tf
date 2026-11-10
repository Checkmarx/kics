# HCL policy document, sub only excluded with StringNotEquals (not an allow-list)
data "aws_iam_policy_document" "positive10" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:someoneelse/otherrepo:ref:refs/heads/main"]
    }
  }
}
