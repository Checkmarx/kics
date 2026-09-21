resource "aws_sns_topic" "positive1" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
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
