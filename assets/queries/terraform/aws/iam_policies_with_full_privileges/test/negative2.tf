resource "aws_iam_role_policy" "negative2" {
  name = "apigateway-cloudwatch-logging"
  role = aws_iam_role.apigateway_cloudwatch_logging.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["*"],
      "Resource": "arn:aws:s3:::*"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "example" {
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = [
      "arn:aws:s3:::*",
    ]
  }
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "read"
    ]
    resources = [
      "*",
    ]
  }
}
