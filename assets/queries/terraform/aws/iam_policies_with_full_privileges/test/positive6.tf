resource "aws_iam_policy" "positive6-1" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["*"],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "positive6-2" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["iam:*"],
      "Resource": "*"
    }
  ]
}
EOF
}