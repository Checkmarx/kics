resource "aws_iam_account_password_policy" "no_uppercase" {
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = false
  require_symbols                = true
  allow_users_to_change_password = true
}

resource "aws_iam_account_password_policy" "missing_uppercase" {
  minimum_password_length        = 3
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
}