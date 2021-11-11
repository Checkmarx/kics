# given:
#  - unused security group
#  - used security group
#  - aws_instance
# when:
#  - used security group attached to aws_instance
#  - unused security group not attached to aws_instance
# then:
#  - detect only unused security group as unused

resource "aws_instance" "positive1" {
  ami = "ami-003634241a8fcdec0"

  instance_type = "t2.micro"

  vpc_security_group_ids = [ aws_security_group.used_sg.id ]
}

resource "aws_security_group" "unused_sg" {
  name        = "unused-sg"
  description = "Unused security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Some port"
    from_port        = 42
    to_port          = 42
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_security_group" "used_sg" {
  name        = "used-sg"
  description = "Used security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Some port"
    from_port        = 43
    to_port          = 43
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}