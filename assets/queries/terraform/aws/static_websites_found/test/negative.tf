#this code is a correct code for which the query should not find any result
resource "aws_s3_bucket" "website_negative" {
  bucket = "s3-website-test.hashicorp.com"
  acl    = "public-read"
  # policy = file("policy.json")
}