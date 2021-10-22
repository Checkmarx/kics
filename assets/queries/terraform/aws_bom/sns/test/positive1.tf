resource "aws_sns_topic" "positive1" {
  name                        = "user-updates-topic.fifo"
  fifo_topic                  = true
  content_based_deduplication = true
}
