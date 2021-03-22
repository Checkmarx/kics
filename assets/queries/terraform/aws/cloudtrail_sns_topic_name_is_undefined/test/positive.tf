resource "aws_cloudtrail" "positive1" {
  # ... other configuration ...
}

resource "aws_cloudtrail" "positive2" {
  # ... other configuration ...

  sns_topic_name = null
}