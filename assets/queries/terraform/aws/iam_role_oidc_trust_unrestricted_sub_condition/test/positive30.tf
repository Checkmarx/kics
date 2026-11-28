# JSON role policy, StringLike sub with a wildcard after a literal owner/repo prefix - still
# reaches any org/repo an attacker can register starting with those prefixes
resource "aws_iam_role" "positive30" {
  name = "positive30"

  assume_role_policy = <<EOF2
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "StringLike": { "token.actions.githubusercontent.com:sub": "repo:octo-org*/octo-repo*:ref:refs/heads/main" } }
    }
  ]
}
EOF2
}
