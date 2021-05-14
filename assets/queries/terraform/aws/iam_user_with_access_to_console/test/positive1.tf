resource "aws_iam_user" "example" {
  name          = "example"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "example_login" {
  user    = aws_iam_user.example.name
  pgp_key = "keybase:some_person_that_exists"
}
