resource "aws_iam_user_policy" "negative11" {
  name = "negative11_${var.environment}"
  user = aws_iam_user.example_user.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExampleUserPolicyString",
            "Effect": "Deny",
            "Action": "ssm:GetParameters",
            "Resource": "*"
        },
        {
            "Sid": "ExampleUserPolicyArray",
            "Effect": "Deny",
            "Action": [
                "ssm:GetParametersByPath"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}