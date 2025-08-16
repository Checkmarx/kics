resource "aws_iam_user_group_membership" "user_group_membership" {
  user = var.user_iam
  groups = aws_iam_group.group1.name
}
