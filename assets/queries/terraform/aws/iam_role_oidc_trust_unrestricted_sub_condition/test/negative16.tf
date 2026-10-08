# JSON role policy, ForAnyValue:StringEquals sub with a specific repository
resource "aws_iam_role" "negative16" {
  name = "negative16"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" },
      "Condition": { "ForAnyValue:StringEquals": { "token.actions.githubusercontent.com:sub": ["repo:myorg/myrepo:ref:refs/heads/main"] } }
    }
  ]
}
EOF
}
