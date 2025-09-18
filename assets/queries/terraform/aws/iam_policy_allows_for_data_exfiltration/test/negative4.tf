resource "aws_iam_role_policy" "negative4" {
  name = "negative4_${var.environment}"
  role = aws_iam_role.example_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExampleRolePolicyString",
            "Effect": "Allow",
            "Action": "safe_string_action",
            "Resource": "*"
        },
        {
            "Sid": "ExampleRolePolicyArray",
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
