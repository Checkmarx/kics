data "aws_iam_policy_document" "negative4" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEqualsIgnoreCase"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:myorg/myrepo:ref:refs/heads/main"]
    }
  }
}
