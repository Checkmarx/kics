# JSON role policy, StringLikeIfExists sub 'repo:*'
resource "aws_iam_role" "positive20" {
  name = "positive20"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "StringLikeIfExists": { "token.actions.githubusercontent.com:sub": "repo:*" } }
    }
  ]
}
EOF
}
