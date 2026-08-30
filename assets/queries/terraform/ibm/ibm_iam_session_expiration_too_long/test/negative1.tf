resource "ibm_iam_account_settings" "settings_secure" {
  mfa                           = "LEVEL2"
  session_expiration_in_seconds = 3600 # 1 Hora
}