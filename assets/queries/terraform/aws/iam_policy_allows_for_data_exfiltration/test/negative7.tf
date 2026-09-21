data "aws_iam_policy_document" "negative7" {
  statement {
    sid     = "negative7_1"
    effect  = "Allow"
    actions = [
      "safe_array_action"
    ]
    resources = ["*"]
  }
  statement {
    sid     = "negative7_2"
    effect  = "Allow"
    actions = [
      "safe_array_action_2"
    ]
    resources = ["*"]
  }
}