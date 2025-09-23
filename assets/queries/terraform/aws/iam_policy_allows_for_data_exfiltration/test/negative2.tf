resource "aws_iam_group_policy" "negative2" {
  name  = "negative2_${var.environment}"
  group = aws_iam_group.example_group.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExampleGroupPolicyString",
            "Effect": "Allow",
            "Action": "safe_string_action",
            "Resource": "*"
        },
        {
            "Sid": "ExampleGroupPolicyArray",
            "Effect": "Allow",
            "Action": [
                "safe_array_action"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
