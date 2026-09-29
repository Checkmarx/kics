data "aws_iam_policy_document" "positive4" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::123456789012:oidc-provider/gitlab.example.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "gitlab.example.com:aud"
      values   = ["https://gitlab.example.com"]
    }
  }
}
