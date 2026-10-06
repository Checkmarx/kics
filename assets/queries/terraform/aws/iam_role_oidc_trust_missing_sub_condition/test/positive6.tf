data "aws_iam_policy_document" "positive6" {
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
