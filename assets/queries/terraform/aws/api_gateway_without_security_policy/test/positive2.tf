resource "aws_api_gateway_domain_name" "example2" {
  domain_name              = "api.example.com"
  security_policy = "TLS_1_0"
}
