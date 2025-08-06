
resource "aws_iam_group" "group1" {
  name = "test"
}

resource "aws_iam_user_group_membership" "user_group_membership" {
  user = var.user_iam
  groups = aws_iam_group.group1.name
}

resource "aws_iam_group_policy_attachment" "group_attachment" {
  group      = aws_iam_group.group1.name
  policy_arn = aws_iam_policy.ECR_policy.arn
}
