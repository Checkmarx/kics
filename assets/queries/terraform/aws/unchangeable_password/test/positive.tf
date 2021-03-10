resource "aws_sqs_queue" "positive1" {
  name = "examplequeue"
}

// comment
resource "aws_iam_account_password_policy" "positive2" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = false
}