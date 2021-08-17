data "aws_vpc_peering_connection" "pc" {
  vpc_id          = aws_vpc.foo.id
  peer_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.foo.id

  route = [
    {
      cidr_block = "10.0.1.0/24"
      gateway_id = aws_internet_gateway.example.id
    }
  ]

  tags = {
    Name = "example"
  }
}

# Create a route
resource "aws_route" "r" {
  route_table_id            = aws_route_table.example.id
  destination_cidr_block    = data.aws_vpc_peering_connection.pc.peer_cidr_block
  vpc_peering_connection_id = data.aws_vpc_peering_connection.pc.id
}
