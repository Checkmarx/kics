resource "aws_network_interface" "multi-ip" {
  subnet_id   = aws_subnet.main.id
}

resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.multi-ip.id
}

resource "aws_eip" "two" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.multi-ip.id
}