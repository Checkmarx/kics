resource "aws_ses_identity_policy" "positive1" {
  identity = aws_ses_domain_identity.example.arn
  name     = "example"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Principal": {
        "AWS": "*"
      },
      "Effect": "Allow",
      "Resource": "*",
      "Sid": ""
    }
  ]
}
EOF
}
