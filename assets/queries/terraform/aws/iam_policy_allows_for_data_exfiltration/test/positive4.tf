resource "aws_iam_user_policy" "positive4" {
  name = "positive4_${var.environment}"
  user = aws_iam_user.example_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExampleUserPolicyString",
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "*"
        },
        {
            "Sid": "ExampleUserPolicyArray",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
