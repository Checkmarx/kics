# JSON role policy, sub only checked with the Null operator (not an allow-list)
resource "aws_iam_role" "positive28" {
  name = "positive28"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "Null": { "token.actions.githubusercontent.com:sub": "false" } }
    }
  ]
}
EOF
}
