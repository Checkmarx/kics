resource "aws_cognito_user_pool" "fail" {
  name = "my-user-pool"

  user_pool_add_ons {
    advanced_security_mode = "OFF"
  }
}
