resource "aws_iam_group_policy" "negative4-1" {
  name  = "my_developer_policy"
  group = aws_iam_group.my_developers.name
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

resource "aws_iam_group_policy" "negative4-2" {
  name  = "my_developer_policy"
  group = aws_iam_group.my_developers.name
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