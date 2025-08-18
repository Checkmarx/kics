# security groups main.tf

#-----------------------------------------------------------------
# Create EC2 Security Group
#-----------------------------------------------------------------

resource "aws_security_group" "ec2" {
  description = "ec2 sg"
  name        = "secgroup-ec2"
  vpc_id      = var.vpc_id
}

#-----------------------------------------------------------------
# Allows ingress traffic from Internet to risky ports:
# Wiz Config Rules: 
#   VPC-029	EC2 Security Group should restrict PostgreSQL access (TCP:5432)
#-----------------------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "positive1-postgreSQL" {
  security_group_id = aws_security_group.ec2.id
  description = "allows PostgreSQL from Internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 5432 # this should be detected if from_port is 5432 and cidr_ipv4 is "0.0.0.0/0"
  ip_protocol = "tcp"
  to_port     = 5432
}