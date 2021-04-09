resource "aws_api_gateway_domain_name" "example4" {
  domain_name              = "api.example.com"
  security_policy = "TLS_1_2"
}
