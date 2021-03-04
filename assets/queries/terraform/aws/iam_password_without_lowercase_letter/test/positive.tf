resource "aws_iam_account_password_policy" "no_lowercase" {
  require_lowercase_characters   = false
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

resource "aws_iam_account_password_policy" "missing_lowercase" {
  minimum_password_length        = 3
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}