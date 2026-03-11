resource "aws_cognito_user_pool" "pass" {
  name = "my-user-pool"

  user_pool_add_ons {
    advanced_security_mode = "ENFORCED"
  }
}
