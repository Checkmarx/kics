resource "aws_cloudtrail" "sns_topic_valid" {
  # ... other configuration ...

  sns_topic_name = "some-topic"
}