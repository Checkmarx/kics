resource "aws_vpc" "main2" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "negative1" {
  vpc_id     = aws_vpc.main2.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Negative1"
  }
}
