resource "aws_s3_bucket" "attachments_bucket" {
  bucket = "${local.env_app_name}-attachments"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${local.env_app_name}-attachments-logs"
}

resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.attachments_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}
