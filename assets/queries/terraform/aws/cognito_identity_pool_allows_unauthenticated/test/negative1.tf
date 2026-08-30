resource "aws_cognito_identity_pool" "pass" {
  identity_pool_name               = "my-identity-pool"
  allow_unauthenticated_identities = false
}
