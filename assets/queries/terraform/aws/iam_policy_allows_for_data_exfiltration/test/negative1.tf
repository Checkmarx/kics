resource "aws_iam_policy" "negative1" {
  name        = "negative1_${var.environment}"
  description = "Kai Monkey SSM Secrets Policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "KaiMonkeySSMSecretsPolicyGet",
            "Effect": "Allow",
            "Action": "safe_string_action",
            "Resource": "*"
        },
        {
            "Sid": "KaiMonkeySSMSecretsPolicyGetDecrypt",
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
