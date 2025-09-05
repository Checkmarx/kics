resource "aws_iam_group_policy" "positive5-1" {
  name  = "my_developer_policy"
  group = aws_iam_group.my_developers.name
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

resource "aws_iam_group_policy" "positive5-2" {
  name  = "my_developer_policy"
  group = aws_iam_group.my_developers.name
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