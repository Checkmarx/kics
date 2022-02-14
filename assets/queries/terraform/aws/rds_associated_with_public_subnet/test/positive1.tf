resource "aws_db_instance" "positive1" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "positive1.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.subnetGroup.name
}

resource "aws_db_subnet_group" "subnetGroup" {
  name       = "main"
  subnet_ids = [aws_subnet.frontend.id, aws_subnet.backend.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_subnet" "frontend" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block = "172.2.0.0/24"
}


resource "aws_subnet" "backend" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block = "0.0.0.0/0"
}
