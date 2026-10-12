# JSON role policy, Cognito Identity Pool trust: Federated principal is the fixed
# cognito-identity.amazonaws.com service, restricted via ':aud' (the identity pool), not ':sub'.
# This is AWS's documented pattern for Cognito and is outside the scope of this query.
resource "aws_iam_role" "negative19" {
  name = "negative19"

  assume_role_policy = <<EOF2
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": { "Federated": "cognito-identity.amazonaws.com" },
      "Condition": {
        "StringEquals": { "cognito-identity.amazonaws.com:aud": "us-east-1:12345678-1234-1234-1234-123456789012" },
        "ForAnyValue:StringLike": { "cognito-identity.amazonaws.com:amr": "authenticated" }
      }
    }
  ]
}
EOF2
}
