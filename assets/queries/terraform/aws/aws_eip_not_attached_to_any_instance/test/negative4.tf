resource "aws_eip" "transfer_eip" {
  domain = "vpc"
}

resource "aws_transfer_server" "sftp" {
  endpoint_type = "VPC"

  endpoint_details {
    address_allocation_ids = [aws_eip.transfer_eip.id]
    subnet_ids             = [aws_subnet.transfer_subnet.id]
    vpc_id                 = aws_vpc.main.id
  }

  identity_provider_type = "SERVICE_MANAGED"
  protocols              = ["SFTP"]
}
