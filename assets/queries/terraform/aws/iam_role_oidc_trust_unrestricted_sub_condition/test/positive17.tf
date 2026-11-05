# JSON role policy, StringLike sub is a bare '*'
resource "aws_iam_role" "positive17" {
  name = "positive17"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "StringLike": { "token.actions.githubusercontent.com:sub": "*" } }
    }
  ]
}
EOF
}
