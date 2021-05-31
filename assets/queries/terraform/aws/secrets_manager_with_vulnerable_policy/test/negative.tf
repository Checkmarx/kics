resource "aws_secretsmanager_secret" "example2" {
  name = "example"
}

resource "aws_secretsmanager_secret_policy" "example2" {
  secret_arn = aws_secretsmanager_secret.example2.arn

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableAllPermissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::var.account_id:saml-provider/var.provider_name"
      },
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "*"
    }
  ]
}
POLICY
}
