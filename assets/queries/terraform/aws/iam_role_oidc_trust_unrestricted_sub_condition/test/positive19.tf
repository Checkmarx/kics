# JSON role policy, StringLike sub with leading wildcard '*:ref:...'
resource "aws_iam_role" "positive19" {
  name = "positive19"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "StringLike": { "token.actions.githubusercontent.com:sub": "*:ref:refs/heads/main" } }
    }
  ]
}
EOF
}
