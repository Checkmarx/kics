#this is a problematic code where the query should report a result(s)
resource "aws_s3_bucket" "website_positive" {
  bucket = "s3-website-test.hashicorp.com"
  acl    = "public-read"
  # policy = file("policy.json")

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}