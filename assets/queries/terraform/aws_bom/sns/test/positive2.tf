resource "aws_sns_topic" "positive2" {
  name = "user-updates-topic"
}

resource "aws_sns_topic_policy" "positive2" {
  arn = aws_sns_topic.positive2.arn

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSConfigSNSPolicy20180202",
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "aws_sns_topic.positive2.arn",
      "Principal": {
        "AWS": "*"
      }
    }
  ]
}
EOF
}
