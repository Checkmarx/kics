resource "aws_elasticsearch_domain" "not_encrypted_at_rest" {
  domain_name           = "example"
  elasticsearch_version = "1.5"
}

resource "aws_elasticsearch_domain" "encrypted_at_rest_disabled" {
  domain_name           = "example"
  elasticsearch_version = "1.5"

  encrypt_at_rest {
      enabled = false
  }
}