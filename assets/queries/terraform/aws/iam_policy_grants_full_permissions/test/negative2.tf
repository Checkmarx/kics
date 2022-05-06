resource "aws_iam_policy" "s3-permission" {
  name   = "s3-permission"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*",
        "s3:*",
        "lambda:*",
        "cloudwatch:*"
      ],
      "Effect": "Allow",
      "Resource": "SomeResource"
    }
  ]
}
EOF
}
