data "aws_vpc_peering_connection" "pc2" {
  vpc_id          = aws_vpc.foo2.id
  peer_cidr_block = "10.0.1.0/22"
}

resource "aws_route_table" "example2" {
  vpc_id = aws_vpc.foo2.id

 route = [
    {
      cidr_block = "10.0.1.0/24"
      gateway_id = aws_internet_gateway.example.id
    },
    {
      ipv6_cidr_block        = "::/0"
      egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
    }
  ]

  tags = {
    Name = "example"
  }
}

# Create a route
resource "aws_route" "r2" {
  route_table_id            = aws_route_table.example2.id
  destination_cidr_block    = data.aws_vpc_peering_connection.pc2.peer_cidr_block
  vpc_peering_connection_id = data.aws_vpc_peering_connection.pc2.id
}
