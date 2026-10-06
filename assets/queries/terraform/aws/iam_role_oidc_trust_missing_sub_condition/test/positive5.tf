resource "aws_iam_role" "positive5" {
  name = "github-actions-role-excludes-only"

  assume_role_policy = <<EOF2
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
      },
      "Condition": {
        "StringNotEquals": {
          "token.actions.githubusercontent.com:sub": "repo:someoneelse/otherrepo:ref:refs/heads/main"
        }
      }
    }
  ]
}
EOF2
}
