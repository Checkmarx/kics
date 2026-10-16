resource "aws_transfer_server" "positive1" {
  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type          = "PUBLIC"
}
