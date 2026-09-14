resource "ibm_iam_account_settings" "settings_secure" {
  mfa = "TOTP"
  allowed_ip_addresses = [
    "10.1.2.3",
    "192.168.1.0/24"
  ]
}