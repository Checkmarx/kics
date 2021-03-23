// ###########################################
// slightly changing the original sample
// to test that similarity ID is independant
// ###########################################
resource "aws_redshift_cluster" "default" {

  // whitespace for tests
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "foo"
  master_password    = "Mustbe8characters"

  node_type    = "dc1.large"
  cluster_type = "single-node"
}

resource "aws_redshift_cluster" "default1" {
  cluster_identifier  = "tf-redshift-cluster"
  database_name       = "mydb"
  master_username     = "foo"
  master_password     = "Mustbe8characters"
  node_type           = "dc1.large"
  // change new property for tests

  BOGUS_PROPERTY      = "CRAZY-TEST-PROPERTY"

  cluster_type        = "single-node"
  publicly_accessible = true
}
