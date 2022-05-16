resource "alicloud_slb_tls_cipher_policy" "positive" {
  tls_cipher_policy_name = "Test-example_value"
  tls_versions           = ["TLSv1.1","TLSv1.2"]
  ciphers                = ["AES256-SHA","AES256-SHA256", "AES128-GCM-SHA256"]
}
