resource "aws_sns_topic" "positive4" {
  name = "user-updates-topic"

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
      "Resource": "aws_sns_topic.positive4.arn",
      "Principal": {
        "AWS": "*"
      }
    }
  ]
}
EOF
}
