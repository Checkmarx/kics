resource "aws_transfer_server" "negative1" {
  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type          = "VPC"
  endpoint_details {
    vpc_id = aws_vpc.example.id
  }
}
