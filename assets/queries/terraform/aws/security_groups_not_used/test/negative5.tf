# given:
#  - used security group
#  - aws_eks_cluster
# when:
#  - used security group attached to aws_eks_cluster
# then:
#  - do not detect any unused security group

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

resource "aws_eks_cluster" "negative3" {
  name = "beautiful-eks"

  role_arn = aws_iam_role.example.arn

  vpc_config {
    security_group_ids = [ "aws_security_group.used_sg.id" ]
  }
}

