provider "aws" {
  region = "us-east-1"
}

resource "aws_secretsmanager_secret" "not_secure_policy" {
  name = "not_secure_secret"
}

resource "aws_secretsmanager_secret_policy" "example" {
  secret_arn = aws_secretsmanager_secret.not_secure_policy.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "secretsmanager:*",
      "Resource": "*"
    }
  ]
}
POLICY
}
