resource "aws_sns_topic" "negative3" {
policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "*"
      ],
      "Resource": "arn:aws:sns:${var.aws_region}:${var.aws_account_number}:forensics_sns_topic",
      "Condition": {
        "StringEquals": {
          "AWS:SourceAccount": "${var.aws_account_number}"
        }
      }
    }
  ]
}
EOF
}