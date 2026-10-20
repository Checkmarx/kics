# JSON role policy, only sts:TagSession action (not web identity)
resource "aws_iam_role" "negative18" {
  name = "negative18"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:TagSession"],
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" }
    }
  ]
}
EOF
}
