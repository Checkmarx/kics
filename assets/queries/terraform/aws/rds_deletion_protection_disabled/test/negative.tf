resource "aws_db_instance" "negative1" {
  allocated_storage   = 10
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  deletion_protection = true
}

resource "aws_rds_cluster" "negative2" {
  cluster_identifier  = "aurora-cluster-negative2"
  engine              = "aurora-mysql"
  master_username     = "foo"
  master_password     = "barbarbar"
  deletion_protection = true
}
