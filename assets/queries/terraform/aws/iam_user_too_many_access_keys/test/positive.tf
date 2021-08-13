resource "aws_iam_access_key" "positive1" {
  user    = aws_iam_user.lb.name
  pgp_key = "keybase:some_person_that_exists"
}

resource "aws_iam_access_key" "positive2" {
  user    = aws_iam_user.lb.name
  pgp_key = "keybase:some_person_that_exists"
}


resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/system/"
}
