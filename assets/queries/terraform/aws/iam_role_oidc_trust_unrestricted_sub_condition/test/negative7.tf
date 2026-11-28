# JSON role policy, StringLike sub scoped to one organization 'repo:myorg/*'
resource "aws_iam_role" "negative7" {
  name = "negative7"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "StringLike": { "token.actions.githubusercontent.com:sub": "repo:myorg/*" } }
    }
  ]
}
EOF
}
