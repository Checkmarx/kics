resource "aws_iam_user" "negative1" {
  name          = "${local.resource_prefix.value}-user"
  force_destroy = true

  tags = {
    Name        = "${local.resource_prefix.value}-user"
    Environment = local.resource_prefix.value
  }

}

resource "aws_iam_access_key" "negative2" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "negative3" {
  name = "excess_policy"
  user = aws_iam_user.user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*",
        "s3:*",
        "lambda:*",
        "cloudwatch:*"
      ],
      "Effect": "Allow",
      "Resource": "SomeResource"
    }
  ]
}
EOF
}

output "username" {
  value = aws_iam_user.user.name
}

output "secret" {
  value = aws_iam_access_key.user.encrypted_secret
}

