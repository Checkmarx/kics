resource "aws_vpc" "mainvpc2" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_default_security_group" "default2" {
  vpc_id = aws_vpc.mainvpc2.id
}
