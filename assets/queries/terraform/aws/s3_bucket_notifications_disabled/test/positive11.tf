resource "aws_sqs_queue" "queue" {
  name   = "s3-event-notification-queue"
  policy = data.aws_iam_policy_document.queue.json
}