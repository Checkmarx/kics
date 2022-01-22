resource "aws_db_instance" "positive2" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "positive2.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = "subnetGroup2"
}

resource "aws_db_subnet_group" "subnetGroup2" {
  name       = "main"
  subnet_ids = [aws_subnet.frontend2.id, aws_subnet.backend2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_subnet" "frontend2" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block = "172.2.0.0/24"
}


resource "aws_subnet" "backend2" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block = "0.0.0.0/0"
}
