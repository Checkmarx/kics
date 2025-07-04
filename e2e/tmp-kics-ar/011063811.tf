resource "alicloud_ram_account_password_policy" "corporate1" {
  minimum_password_length = 14
  require_lowercase_characters = false
  require_uppercase_characters = false
  require_numbers              = false
  require_symbols              = true
  max_password_age = 12
  hard_expiry                  = true
  password_reuse_prevention    = 5
  max_login_attempts           = 3
}

resource "alicloud_ram_account_password_policy" "corporate2" {
  max_password_age = 12
  minimum_password_length = 14
  require_lowercase_characters = false
  require_uppercase_characters = false
  require_numbers              = false
  require_symbols              = true
  hard_expiry                  = true
  password_reuse_prevention    = 5
  max_login_attempts           = 3
}
