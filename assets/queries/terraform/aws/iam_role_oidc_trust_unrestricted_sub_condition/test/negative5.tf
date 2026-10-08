# JSON role policy, array Action, StringLike sub with wildcard only in the ref segment
resource "aws_iam_role" "negative5" {
  name = "negative5"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRoleWithWebIdentity"],
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "StringLike": { "token.actions.githubusercontent.com:sub": "repo:myorg/myrepo:ref:refs/heads/*" } }
    }
  ]
}
EOF
}
