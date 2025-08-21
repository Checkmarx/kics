module "vote_service_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 2300
      to_port     = 3000
      protocol    = "-1"
      cidr_blocks = ["10.92.168.0/28","0.0.0.0/0"]
    }
  ]
}

module "vote_service_sg_array" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 2383
      to_port     = 2383
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0", "1.2.3.4/27"]
    },
    {
      description = "TLS from VPC"
      from_port   = 28000
      to_port     = 28001
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    },
    {
      description = "TLS from VPC"
      from_port   = 2000
      to_port     = 2500
      protocol    = "tcp"
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}

