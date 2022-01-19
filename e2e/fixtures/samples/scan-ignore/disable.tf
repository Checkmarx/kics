# kics-scan disable=0a494a6a-ebe2-48a0-9d77-cf9d5125e1b3,15ffbacc-fa42-4f6f-a57d-2feac7365caa,41abc6cc-dde1-4217-83d3-fb5f0cc09d8f,e592a0c5-5bdb-414c-9066-5dba7cdea370
resource "aws_redshift_cluster" "default1" {
  publicly_accessible = false
  encrypted=true
}
