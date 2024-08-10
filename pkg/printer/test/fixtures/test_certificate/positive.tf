resource "aws_api_gateway_domain_name" "example2" {
  certificate_body = file("certificate.pem")
  domain_name     = "api.example.com"
}

