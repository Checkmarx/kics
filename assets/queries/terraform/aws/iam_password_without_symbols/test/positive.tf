resource "aws_iam_account_password_policy" "false_symbol" {
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
}

resource "aws_iam_account_password_policy" "no_symbol" {
  minimum_password_length        = 3
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  allow_users_to_change_password = true
}