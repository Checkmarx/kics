# JSON role policy, lowercase action name, no Condition
resource "aws_iam_role" "positive5" {
  name = "positive5"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:assumerolewithwebidentity",
      "Effect": "Allow",
      "Principal": { "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com" }
    }
  ]
}
EOF
}
