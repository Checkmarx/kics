resource "aws_cognito_identity_pool" "fail" {
  identity_pool_name               = "my-identity-pool"
  allow_unauthenticated_identities = true
}
