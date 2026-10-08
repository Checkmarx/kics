# JSON role policy, sts:AssumeRole for a Service principal (not OIDC)
resource "aws_iam_role" "negative9" {
  name = "negative9"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com" }
    }
  ]
}
EOF
}
