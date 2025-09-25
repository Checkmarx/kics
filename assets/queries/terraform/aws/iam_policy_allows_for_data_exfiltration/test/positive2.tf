resource "aws_iam_policy" "positive2" {
  name        = "positive2"
  description = "Provides full access to AWS services and resources."
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
        "*"
      ],
            "Resource": "*"
        }
    ]
}
POLICY
}
