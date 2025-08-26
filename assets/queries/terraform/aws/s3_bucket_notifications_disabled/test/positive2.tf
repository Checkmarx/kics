resource "aws_sqs_queue" "queue1" {
  name   = "s3-event-notification-queue"
  policy = data.aws_iam_policy_document.queue.json
}

resource "aws_sqs_queue" "queue2" {
  name   = "s3-event-notification-queue"
  policy = data.aws_iam_policy_document.queue.json
}

resource "aws_s3_bucket" "bucket" {
  bucket = "your-bucket-name"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  queue {
    queue_arn     = aws_sqs_queue.queue1.arn
    events        = ["s3:ObjectCreated:Post"]
    filter_prefix = "images/"
  }

  queue {
    queue_arn     = aws_sqs_queue.queue1.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "videos/"
  }
}