resource "ibm_iam_account_settings" "iam_no_mfa" {
  # Falta el atributo mfa
  session_expiration_in_seconds = 3600
}