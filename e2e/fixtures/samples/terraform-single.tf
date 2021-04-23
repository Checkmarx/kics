resource "aws_redshift_cluster" "default1" {
  publicly_accessible = false
  encrypted=true
}
