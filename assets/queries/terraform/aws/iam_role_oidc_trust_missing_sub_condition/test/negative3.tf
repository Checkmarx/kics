resource "aws_iam_role" "negative3" {
  name = "github-actions-role-safe-ignorecase"

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
        "StringEqualsIgnoreCase": {
          "token.actions.githubusercontent.com:sub": "repo:myorg/myrepo:ref:refs/heads/main"
        }
      }
    }
  ]
}
EOF2
}
