resource "aws_sqs_queue" "negative1" {
  name = "examplequeue"
}

// comment
resource "aws_iam_account_password_policy" "negative2" {
  minimum_password_length        = 10
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}