provider "aws" {
  region = "us-west-2"  # Replace with your desired AWS region
}

resource "aws_rds_cluster" "my_cluster" {
  cluster_identifier            = "my-cluster"
  engine                       = "aurora-mysql"
  engine_version               = "5.7.mysql_aurora.2.08.0"
  master_username              = "admin"
  master_password              = "password"
  backup_retention_period      = 7
  preferred_backup_window      = "02:00-03:00"
  deletion_protection          = false
  skip_final_snapshot          = true
  apply_immediately            = true
  storage_encrypted            = false
}

resource "aws_rds_cluster_instance" "my_cluster_instance" {
  identifier                    = "my-cluster-instance"
  cluster_identifier            = aws_rds_cluster.my_cluster.id
  engine                        = "aurora-mysql"
  instance_class                = "db.r5.large"
  publicly_accessible           = false
  availability_zone             = "us-west-2a"  # Replace with your desired availability zone
}

output "cluster_endpoint" {
  value = aws_rds_cluster.my_cluster.endpoint
}
