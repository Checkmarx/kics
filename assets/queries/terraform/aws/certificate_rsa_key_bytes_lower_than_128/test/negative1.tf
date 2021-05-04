resource "aws_api_gateway_domain_name" "example3" {
  certificate_body = file("./rsa4096.pem")
  domain_name     = "api.example.com"
}
