data "aws_iam_policy_document" "example" {
  statement {
    actions = [
      "cloudwatch:PutMetricData",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "example" {
  name               = "example-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json

  inline_policy {
    name   = "default"
    policy = data.aws_iam_policy_document.example.json
  }
}