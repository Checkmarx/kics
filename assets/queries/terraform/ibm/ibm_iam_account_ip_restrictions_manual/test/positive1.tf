resource "ibm_iam_account_settings" "settings_no_ips" {
  mfa = "TOTP"
  session_expiration_in_seconds = 3600
}