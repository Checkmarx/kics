locals {
  support_site_bucket_name = "support-site-${var.stack}-${var.environment}${var.bucket_name_suffix}"
}

resource "aws_s3_bucket" "support_site_app_bucket" {
  force_destroy = var.destroyable_env
  bucket        = local.support_site_bucket_name
}

resource "aws_cloudfront_origin_access_identity" "support_site_origin_access_identity" {}

data "aws_iam_policy_document" "support_site_bucket_policy_document" {
  version = "2012-10-17"

  statement {
    sid       = "DenyNonSecureTransport"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [
      "arn:aws:s3:::${local.support_site_bucket_name}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid     = "AllowCloudFrontAccess"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.support_site_origin_access_identity.iam_arn]
    }
    resources = [
      "arn:aws:s3:::${local.support_site_bucket_name}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}

resource "aws_s3_bucket_policy" "support_site_app_bucket_policy" {
  depends_on = [aws_s3_bucket.support_site_app_bucket]
  bucket     = aws_s3_bucket.support_site_app_bucket.id
  policy     = data.aws_iam_policy_document.support_site_bucket_policy_document.json
}
