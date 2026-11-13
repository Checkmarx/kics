resource "aws_db_instance" "positive1" {
  allocated_storage   = 10
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  deletion_protection = false
}

resource "aws_db_instance" "positive2" {
  allocated_storage = 10
  engine            = "mysql"
  instance_class    = "db.t3.micro"
}

resource "aws_rds_cluster" "positive3" {
  cluster_identifier  = "aurora-cluster-positive3"
  engine              = "aurora-mysql"
  master_username     = "foo"
  master_password     = "barbarbar"
  deletion_protection = false
}

resource "aws_rds_cluster" "positive4" {
  cluster_identifier = "aurora-cluster-positive4"
  engine             = "aurora-mysql"
  master_username    = "foo"
  master_password    = "barbarbar"
}
