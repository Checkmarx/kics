resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id
}

resource "aws_sns_topic" "topic" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.topic.json
}



