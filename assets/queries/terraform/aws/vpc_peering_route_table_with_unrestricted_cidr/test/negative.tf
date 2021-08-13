data "aws_vpc_peering_connection" "negative1" {
  vpc_id          = aws_vpc.foo2.id
  peer_cidr_block = "10.0.1.0/24"
}

resource "aws_route_table" "example3" {
  vpc_id = aws_vpc.foo2.id

  route = [
    {
      cidr_block = "10.0.1.0/24"
      gateway_id = aws_internet_gateway.example2.id
    }
  ]

  tags = {
    Name = "example"
  }
}

# Create a route
resource "aws_route" "rr" {
  route_table_id            = aws_route_table.example3.id
  destination_cidr_block    = data.aws_vpc_peering_connection.negative1.peer_cidr_block
  vpc_peering_connection_id = data.aws_vpc_peering_connection.negative1.id
}
