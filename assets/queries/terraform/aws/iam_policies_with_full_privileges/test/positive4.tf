resource "aws_iam_user_policy" "positive4-1" {
  name = "test"
  user = aws_iam_user.lb.name
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

resource "aws_iam_user_policy" "positive4-2" {
  name = "test"
  user = aws_iam_user.lb.name
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