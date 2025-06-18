resource "aws_iam_user" "user_one" {
  name = "user_one-example"
}

resource "aws_iam_group" "example_external_users" {
  name = "example-external-users"
}

resource "aws_iam_user_group_membership" "programmatic_user_membership" {
  user = aws_iam_user.user_one.name
  groups = [aws_iam_group.example_external_users.name]
}
