data "aws_iam_policy_document" "positive4" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::123456789012:oidc-provider/gitlab.example.com"]
    }

    condition {
      test     = "StringLike"
      variable = "gitlab.example.com:sub"
      values   = ["project_path:*:ref_type:branch:ref:*"]
    }
  }
}
