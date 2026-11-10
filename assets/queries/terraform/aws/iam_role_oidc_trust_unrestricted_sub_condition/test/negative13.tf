# JSON role policy, StringEquals with literal 'repo:*' is not a wildcard
resource "aws_iam_role" "negative13" {
  name = "negative13"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "StringEquals": { "token.actions.githubusercontent.com:sub": "repo:*" } }
    }
  ]
}
EOF
}
