# HCL policy document, several conditions but sub only uses StringNotLike
data "aws_iam_policy_document" "positive12" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringNotLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:evil/*"]
    }
  }
}
