module "vote_service_sg_ipv4" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "HTTP port open"
  vpc_id      = "vpc-12345678"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 70
      to_port     = 120
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "vote_service_sg_ipv6" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "HTTP port open"
  vpc_id      = "vpc-12345678"

  ingress_with_ipv6_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 70
      to_port     = 120
      protocol    = "tcp"
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}

module "vote_service_sg_ipv4_array" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "HTTP port open"
  vpc_id      = "vpc-12345678"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 0
      to_port     = 100
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/16", "10.0.0.0/8", "0.0.0.0/0"]
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
      from_port   = 78
      to_port     = 84
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

module "vote_service_sg_ipv6_array" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "user-service"
  description = "HTTP port open"
  vpc_id      = "vpc-12345678"

  ingress_with_ipv6_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 0
      to_port     = 100
      protocol    = "-1"
      ipv6_cidr_blocks = ["2001:0db8:85a3:0000:0000:8a2e:0370:7334/24", "2401:fa00:4:1a::abcd/128", "::/0"]
    },
    {
      description = "TLS from VPC"
      from_port   = 28000
      to_port     = 28001
      protocol    = "tcp"
      ipv6_cidr_blocks = ["2606:4700:3033::6815:3e3/56"]
    },
    {
      description = "TLS from VPC"
      from_port   = 79
      to_port     = 81
      protocol    = "tcp"
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}