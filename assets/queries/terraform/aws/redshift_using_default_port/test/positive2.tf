resource "aws_redshift_cluster" "positive2" {
  cluster_identifier    = "tf-redshift-cluster"
  database_name         = "mydb"
  master_username       = "foo"
  master_password       = "Mustbe8characters"
  node_type             = "dc1.large"
  cluster_type          = "single-node"
  publicly_accessible   = false
  port                  = 5439
}
