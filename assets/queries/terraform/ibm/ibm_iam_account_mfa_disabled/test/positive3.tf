resource "ibm_iam_account_settings" "iam_weak_mfa" {
  # FAIL: LEVEL1 no es suficientemente seguro
  mfa = "LEVEL1"
}