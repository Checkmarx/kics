resource "aws_iam_policy" "positive4policy" {
  name        = "positive4policy"
  path        = "/"
  description = "positive4 Policy"
  policy      = data.aws_iam_policy_document.datapositive4policy.json
}
# Terraform's "jsonencode" function converts a
# Terraform expression result to valid JSON syntax.
data "aws_iam_policy_document" "datapositive4policy" {
  statement {
    effect = "Allow"
    action = [
      "lambda:InvokeFunction"
    ]

    resource = [
      "arn:aws:lambda:*:*:function:*:*"
    ]
  }
}
