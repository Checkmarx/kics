resource "aws_iam_group_policy" "negative10" {
  name  = "negative10_${var.environment}"
  group = aws_iam_group.example_group.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExampleGroupPolicyString",
            "Effect": "Deny",
            "Action": "s3:GetObject",
            "Resource": "*"
        },
        {
            "Sid": "ExampleGroupPolicyArray",
            "Effect": "Deny",
            "Action": [
                "ssm:GetParameter"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}