resource "aws_cognito_user_pool" "negative1" {
  # ... other configuration ...

  mfa_configuration          = "ON"
  sms_authentication_message = "Your code is {####}"

  sms_configuration {
    external_id    = "example"
    sns_caller_arn = aws_iam_role.example.arn
  }
}

resource "aws_cognito_user_pool" "negative2" {
  # ... other configuration ...

  mfa_configuration          = "OPTIONAL"
  sms_authentication_message = "Your code is {####}"

  software_token_mfa_configuration {
    enabled = true
  }
}
