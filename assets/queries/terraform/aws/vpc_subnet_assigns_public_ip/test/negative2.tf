resource "aws_vpc" "main3" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "negative2" {
  vpc_id     = aws_vpc.main3.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Negative2"
  }

  map_public_ip_on_launch = false
}
