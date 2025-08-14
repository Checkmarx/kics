resource "aws_iam_policy" "privileged-instance-policy" {
  name        = "privileged-instance-policy"
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
