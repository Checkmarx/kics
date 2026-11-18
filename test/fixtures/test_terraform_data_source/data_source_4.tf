variable "enforce_tls" {
  type    = bool
  default = true
}

data "aws_iam_policy_document" "counted_deny_insecure_transport" {
  count = var.enforce_tls ? 1 : 0

  statement {
    sid       = "DenyInsecureTransport"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::counted/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "for_each_deny_insecure_transport" {
  for_each = toset(["logs", "assets"])

  statement {
    sid       = "DenyInsecureTransport"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::for-each/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  lifecycle {
    postcondition {
      condition     = true
      error_message = "unused"
    }
  }
}
