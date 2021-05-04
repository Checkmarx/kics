resource "aws_api_gateway_domain_name" "example" {
  certificate_body = file("./rsa1024.pem")
  domain_name     = "api.example.com"
}
