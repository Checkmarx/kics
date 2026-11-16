# SNS topic unrelated to S3: no aws_s3_bucket in the file, so there are no bucket notifications to enable
resource "aws_sns_topic" "change" {
  name = "support-change-request"
}
