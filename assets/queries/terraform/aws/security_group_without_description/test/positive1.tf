resource "aws_security_group" "positive1-1" {
  name        = "positive1-1"
  vpc_id      = aws_vpc.main.id

}

resource "aws_security_group" "positive1-2" {
  name        = "positive1-2"
  vpc_id      = aws_vpc.main.id
  description = null

}