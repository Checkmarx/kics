resource "aws_sns_topic" "positive5" {
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
      "Resource": "aws_sns_topic.positive5.arn",
      "Principal" : { 
        "AWS": [ 
          "arn:aws:iam::123456789012:root",
          "arn:aws:iam::555555555555:root" 
          ]
      }
    }
  ]
}
EOF
}
