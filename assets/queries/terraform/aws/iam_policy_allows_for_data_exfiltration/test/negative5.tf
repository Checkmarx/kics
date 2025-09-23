resource "aws_iam_policy" "negative5" {
  name        = "negative5"
  description = "Provides full access to AWS services and resources."
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": [
        "*"
      ],
            "Resource": "*"
        }
    ]
}
POLICY
}
