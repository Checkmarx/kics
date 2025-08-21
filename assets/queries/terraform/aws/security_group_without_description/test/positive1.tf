resource "aws_security_group" "positive1_1" {
  name        = "positive1_1"
  vpc_id      = aws_vpc.main.id

}

resource "aws_security_group" "positive1_2" {
  name        = "positive1_2"
  vpc_id      = aws_vpc.main.id
  description = null

}