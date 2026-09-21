resource "aws_iam_role_policy" "positive5" {
  name = "positive5_${var.environment}"
  role = aws_iam_role.example_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExampleRolePolicyString",
            "Effect": "Allow",
            "Action": "ssm:GetParameters",
            "Resource": "*"
        },
        {
            "Sid": "ExampleRolePolicyArray",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
