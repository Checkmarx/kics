resource "aws_sns_topic" "positive1" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "pos1_1",
      "Effect": "Allow",
      "Action": "*",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "*"
    },
    {
      "Sid": "neg",
      "Effect": "Allow",
      "Action": "*",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Resource": "*"
    },
    {
      "Sid": "pos1_2",
      "Effect": "Allow",
      "Action": "*",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "*"
    }
  ]
}
EOF
}
