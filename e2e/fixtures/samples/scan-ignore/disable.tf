# kics-scan disable=0a494a6a-ebe2-48a0-9d77-cf9d5125e1b3,15ffbacc-fa42-4f6f-a57d-2feac7365caa
resource "aws_redshift_cluster" "default1" {
  publicly_accessible = false
  encrypted=true
}
