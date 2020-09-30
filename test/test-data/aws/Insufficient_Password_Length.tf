// comment
// comment
resource "aws_iam_account_password_policy" "strict2" {
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  minimum_password_length        = 3
}


resource "aws_iam_account_password_policy" "strict_without" {
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}