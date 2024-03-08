resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
  Name = format("my-vpc-%s", var.name)
  Name2 = format("my-vpc-%s", var.name2)
  }
}
