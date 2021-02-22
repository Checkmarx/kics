resource "aws_elasticsearch_domain" "encrypted_at_rest" {
  domain_name           = "example"
  elasticsearch_version = "1.5"

  encrypt_at_rest {
      enabled = true
  }
}