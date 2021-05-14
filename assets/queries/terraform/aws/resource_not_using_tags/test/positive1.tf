resource "aws_acm_certificate" "cert" {
  domain_name       = "example.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "cert_2" {
  domain_name       = "example.com"
  validation_method = "DNS"

  tags = {
    Name = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}
