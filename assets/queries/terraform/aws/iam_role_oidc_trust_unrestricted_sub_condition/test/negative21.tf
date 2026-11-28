# HCL policy document, Cognito Identity Pool trust via a "principals" block - same AWS pattern
# as negative19.tf but in aws_iam_policy_document form, outside the scope of this query.
data "aws_iam_policy_document" "negative21" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = ["us-east-1:12345678-1234-1234-1234-123456789012"]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["authenticated"]
    }
  }
}
