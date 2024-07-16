resource "aws_route_table" "art_nat_gw_out" {
  vpc_id = aws_vpc.av_xxx.id

  route {
    nat_gateway_id = aws_nat_gateway.ngw01.id
    cidr_block     = "0.0.0.0/0"
  }

  route {
    vpc_peering_connection_id = aws_vpc_peering_connection.avpv.id
    cidr_block                = "10.0.0.0/24"
  }
}
