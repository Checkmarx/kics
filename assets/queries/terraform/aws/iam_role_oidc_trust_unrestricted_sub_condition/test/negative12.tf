# HCL policy document, Deny statement without condition
data "aws_iam_policy_document" "negative12" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Deny"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"]
    }
  }
}
