# JSON role policy, Condition only on aud, no sub
resource "aws_iam_role" "positive3" {
  name = "positive3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "StringEquals": { "gitlab.example.com:aud": "https://gitlab.example.com" } }
    }
  ]
}
EOF
}
