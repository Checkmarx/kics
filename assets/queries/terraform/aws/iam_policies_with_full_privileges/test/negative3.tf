resource "aws_iam_user_policy" "negative3-1" {
  name        = "managed-policy-wildcard"
  user = aws_iam_user.lb.name
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

resource "aws_iam_user_policy" "negative3-2" {
  name        = "managed-policy-wildcard"
  user = aws_iam_user.lb.name
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