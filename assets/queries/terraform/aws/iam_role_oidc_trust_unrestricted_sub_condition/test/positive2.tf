# JSON role policy, array Action, no Condition
resource "aws_iam_role" "positive2" {
  name = "positive2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRoleWithWebIdentity"],
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" }
    }
  ]
}
EOF
}
