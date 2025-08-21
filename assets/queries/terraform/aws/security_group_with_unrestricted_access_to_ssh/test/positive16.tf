module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"
  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ingress_with_cidr_blocks = [
    {
      description = "TLS from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      ipv6_cidr_blocks = ["fd00::/8"]
    },
    {
      description = "TLS from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      ipv6_cidr_blocks = ["fd00::/8", "::/0"]
    }
  ]
}
