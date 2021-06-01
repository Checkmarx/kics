provider "aws" {
  region = "us-east-1"
}

data "aws_kms_key" "test" {
  key_id = "alias/aws/rds"
}

resource "aws_docdb_cluster" "test2" {
  cluster_identifier  = "my-docdb-cluster-test2"
  engine              = "docdb"
  master_username     = "foo"
  master_password     = "mustbeeightchars"
  skip_final_snapshot = true
  storage_encrypted   = true
  kms_key_id          = data.aws_kms_key.test.arn
}
