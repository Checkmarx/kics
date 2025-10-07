resource "aws_iam_policy" "positive1" {
  name        = "positive1_${var.environment}"
  description = "Kai Monkey SSM Secrets Policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "KaiMonkeySSMSecretsPolicyGet",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "*"
        },
        {
            "Sid": "KaiMonkeySSMSecretsPolicyGetDecrypt",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "s3:GetObject",
                "ssm:GetParametersByPath",
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
