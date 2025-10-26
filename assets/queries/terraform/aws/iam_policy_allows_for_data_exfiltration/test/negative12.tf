resource "aws_iam_role_policy" "negative12" {
  name = "negative12_${var.environment}"
  role = aws_iam_role.example_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExampleRolePolicyString",
            "Effect": "Deny",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "*"
        },
        {
            "Sid": "ExampleRolePolicyArray",
            "Effect": "Deny",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}