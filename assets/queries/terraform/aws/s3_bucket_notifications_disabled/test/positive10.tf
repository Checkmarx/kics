resource "aws_sns_topic" "topic1" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.topic.json
}