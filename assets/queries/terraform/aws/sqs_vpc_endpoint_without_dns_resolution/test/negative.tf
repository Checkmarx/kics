resource "aws_vpc" "main2" {
  cidr_block = local.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = false
}

resource "aws_vpc_endpoint" "sqs-vpc-endpoint2" {
  vpc_id            = aws_vpc.main2.id
  service_name      = "com.amazonaws.${local.region}.sqs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  subnet_ids = [aws_subnet.public-subnet.id]
  security_group_ids = [aws_security_group.public-internet-sg.id]
}
