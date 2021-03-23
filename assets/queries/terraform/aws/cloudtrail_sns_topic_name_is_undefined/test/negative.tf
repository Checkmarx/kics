resource "aws_cloudtrail" "negative1" {
  # ... other configuration ...

  sns_topic_name = "some-topic"
}