module "sns_topic_with_policy_field" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 6.0"

  name = "example-sns-topic-policy"

  topic_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAllAccounts",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sns:Publish",
      "Resource": "*"
    },
    {
      "Sid": "AllowAllAccounts",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:root"
      },
      "Action": "sns:Publish",
      "Resource": "*"
    },
    {
      "Sid": "AllowAllAccounts",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sns:Publish",
      "Resource": "*"
    }
  ]
}
EOF
}
