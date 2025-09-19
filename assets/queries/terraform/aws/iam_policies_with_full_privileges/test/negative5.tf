resource "aws_iam_policy" "negative5-1" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["some:action"],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "negative5-2" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["*"],
      "Resource": "arn:aws:s3:::*"
    }
  ]
}
EOF
}