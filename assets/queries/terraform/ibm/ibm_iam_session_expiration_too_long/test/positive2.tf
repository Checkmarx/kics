resource "ibm_iam_account_settings" "settings_too_long" {
  session_expiration_in_seconds = 86400 # 24 Horas
}