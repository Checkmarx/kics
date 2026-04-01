resource "aws_iam_role" "positive2" {
  name = "gitlab-ci-wildcard-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:oidc-provider/gitlab.example.com"
      },
      "Condition": {
        "StringLike": {
          "gitlab.example.com:sub": "project_path:*:ref_type:branch:ref:*"
        }
      }
    }
  ]
}
EOF
}
