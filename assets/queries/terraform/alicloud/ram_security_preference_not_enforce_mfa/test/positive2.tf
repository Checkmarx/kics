# Create a new RAM user.
resource "alicloud_ram_user" "user2" {
  name         = "user_test"
  display_name = "user_display_name"
  mobile       = "86-18688888888"
  email        = "hello.uuu@aaa.com"
  comments     = "yoyoyo"
  force        = true
}

resource "alicloud_ram_security_preference" "example2" {
  enable_save_mfa_ticket        = false
  allow_user_to_change_password = true
  enforce_mfa_for_login = false
}
