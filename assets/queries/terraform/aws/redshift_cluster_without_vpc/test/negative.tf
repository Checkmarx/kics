resource "aws_redshift_cluster" "negative1" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "foo"
  master_password    = "Mustbe8characters"
  node_type          = "dc1.large"
  cluster_type       = "single-node"
  logging {
      enable = true
      bucket_name = "nameOfAnExistingS3Bucket"
  }
  vpc_security_group_ids = [
    aws_security_group.redshift.id
  ]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.id
}
