resource "aws_iam_user" "userExample" {
  name = "loadbalancer"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "negative1" {
  user    = aws_iam_user.userExample.name
  pgp_key = "keybase:some_person_that_exists"
}

