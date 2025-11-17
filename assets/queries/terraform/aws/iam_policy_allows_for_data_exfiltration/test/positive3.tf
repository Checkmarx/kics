resource "aws_iam_group_policy" "positive3" {
  name  = "positive3_${var.environment}"
  group = aws_iam_group.example_group.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExampleGroupPolicyString",
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        },
        {
            "Sid": "ExampleGroupPolicyArray",
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
