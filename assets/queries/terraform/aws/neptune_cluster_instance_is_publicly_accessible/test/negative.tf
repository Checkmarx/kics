resource "aws_neptune_cluster_instance" "negative" {
  count              = 2
  cluster_identifier = aws_neptune_cluster.default.id
  engine             = "neptune"
  instance_class     = "db.r4.large"
  apply_immediately  = true
  publicly_accessible = false
}
