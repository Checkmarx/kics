resource "aws_cognito_user_pool" "positive1" {
  # ... other configuration ...

  sms_authentication_message = "Your code is {####}"

  sms_configuration {
    external_id    = "example"
    sns_caller_arn = aws_iam_role.example.arn
  }

  software_token_mfa_configuration {
    enabled = true
  }
}

resource "aws_cognito_user_pool" "positive2" {
  # ... other configuration ...

  mfa_configuration          = "OFF"
  sms_authentication_message = "Your code is {####}"

  sms_configuration {
    external_id    = "example"
    sns_caller_arn = aws_iam_role.example.arn
  }

  software_token_mfa_configuration {
    enabled = true
  }
}

resource "aws_cognito_user_pool" "positive3" {
  # ... other configuration ...

  mfa_configuration          = "ON"
  sms_authentication_message = "Your code is {####}"
}
