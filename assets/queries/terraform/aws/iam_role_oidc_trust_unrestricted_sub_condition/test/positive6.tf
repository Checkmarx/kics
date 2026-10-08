# JSON role policy, Action list with other actions plus web identity, no Condition
resource "aws_iam_role" "positive6" {
  name = "positive6"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole", "sts:AssumeRoleWithWebIdentity"],
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" }
    }
  ]
}
EOF
}
