resource "aws_sns_topic" "forensics_sns_topic" {
  name = "forensics_sns_topic"

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
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Resource": "arn:aws:sns:${var.aws_region}:${var.aws_account_number}:forensics_sns_topic",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws_account_number}"
        }
      }
    }
  ]
}
EOF
}
