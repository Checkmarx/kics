# JSON role policy, sub only excluded with StringNotEquals (not an allow-list)
resource "aws_iam_role" "positive4" {
  name = "positive4"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "StringNotEquals": { "token.actions.githubusercontent.com:sub": "repo:someoneelse/otherrepo:ref:refs/heads/main" } }
    }
  ]
}
EOF
}
