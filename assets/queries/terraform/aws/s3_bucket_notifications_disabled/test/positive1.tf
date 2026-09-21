resource "aws_sns_topic" "topic1" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.topic.json
}

resource "aws_sns_topic" "topic2" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.topic.json
}

resource "aws_s3_bucket" "bucket" {
  bucket = "your-bucket-name"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  topic {
    topic_arn     = aws_sns_topic.topic1.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }

  topic {
    topic_arn     = aws_sns_topic.topic1.arn
    events        = ["s3:ObjectCreated:Post"]
    filter_suffix = ".log"
  }
}