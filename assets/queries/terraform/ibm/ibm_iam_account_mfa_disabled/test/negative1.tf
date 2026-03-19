resource "ibm_iam_account_settings" "iam_secure" {
  # CORRECTO: LEVEL2 es seguro
  mfa = "LEVEL2"
}