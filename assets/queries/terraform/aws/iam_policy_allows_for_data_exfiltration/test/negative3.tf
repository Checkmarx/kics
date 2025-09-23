resource "aws_iam_user_policy" "negative3" {
  name = "negative3_${var.environment}"
  user = aws_iam_user.example_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExampleUserPolicyString",
            "Effect": "Allow",
            "Action": "safe_string_action",
            "Resource": "*"
        },
        {
            "Sid": "ExampleUserPolicyArray",
            "Effect": "Allow",
            "Action": [
                "safe_array_action"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
