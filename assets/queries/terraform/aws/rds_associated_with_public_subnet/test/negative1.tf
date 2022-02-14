resource "aws_db_instance" "negative1" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "negative1.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.subnetGroup3.name
}

resource "aws_db_subnet_group" "subnetGroup3" {
  name       = "main"
  subnet_ids = [aws_subnet.frontend3.id, aws_subnet.backend3.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_subnet" "frontend3" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block = "172.2.0.0/24"
}


resource "aws_subnet" "backend3" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr2.vpc_id
  cidr_block = "176.2.0.0/24"
}
