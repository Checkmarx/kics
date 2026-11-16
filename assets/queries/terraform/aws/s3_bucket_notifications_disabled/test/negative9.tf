# SQS queue unrelated to S3: no aws_s3_bucket in the file, so there are no bucket notifications to enable
resource "aws_sqs_queue" "jobs" {
  name = "background-jobs"
}
