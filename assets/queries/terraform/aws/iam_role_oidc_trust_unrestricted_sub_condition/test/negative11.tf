# HCL policy document, sts:AssumeRole for a Service principal (not OIDC)
data "aws_iam_policy_document" "negative11" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
