resource "aws_redshift_cluster" "positive1" {
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
}
