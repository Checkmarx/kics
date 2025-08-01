resource "aws_iam_role_policy" "negative1" {
  name = "apigateway-cloudwatch-logging"
  role = aws_iam_role.apigateway_cloudwatch_logging.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["some:action"],
      "Resource": "*"
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
}
