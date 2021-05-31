data "aws_iam_policy_document" "test_destination_policy2" {
  statement {
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "123456789012",
      ]
    }

    actions = [
      "logs:PutSubscriptionFilter",
    ]

    resources = [
      aws_cloudwatch_log_destination.test_destination.arn,
    ]
  }
}

resource "aws_cloudwatch_log_destination_policy" "test_destination_policy2" {
  destination_name = aws_cloudwatch_log_destination.test_destination.name
  access_policy    = data.aws_iam_policy_document.test_destination_policy2.json
}
