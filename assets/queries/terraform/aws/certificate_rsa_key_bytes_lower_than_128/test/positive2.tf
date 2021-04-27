resource "aws_iam_server_certificate" "test_cert2" {
  name             = "some_test_cert"
  certificate_body = file("rsa1024.pem")
  private_key      = file("test-key.pem")
}
