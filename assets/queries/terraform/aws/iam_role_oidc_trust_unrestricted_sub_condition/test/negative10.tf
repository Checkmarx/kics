# JSON role policy, sts:AssumeRoleWithSAML (not web identity)
resource "aws_iam_role" "negative10" {
  name = "negative10"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithSAML",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" }
    }
  ]
}
EOF
}
