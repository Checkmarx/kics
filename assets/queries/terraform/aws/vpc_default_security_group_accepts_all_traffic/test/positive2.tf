resource "aws_vpc" "mainvpc3" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_default_security_group" "default3" {
  vpc_id = aws_vpc.mainvpc3.id

  ingress = [
    {
      protocol  = -1
      self      = true
      from_port = 0
      to_port   = 0
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
