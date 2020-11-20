resource "aws_cloudtrail" "no_sns_topic" {
  # ... other configuration ...
}

resource "aws_cloudtrail" "sns_topic_null" {
  # ... other configuration ...

  sns_topic_name = null
}