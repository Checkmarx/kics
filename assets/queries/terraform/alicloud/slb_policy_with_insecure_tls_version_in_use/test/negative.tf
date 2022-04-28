resource "alicloud_slb_tls_cipher_policy" "negative" {
  tls_cipher_policy_name = "Test-example_value"
  tls_versions           = ["TLSv1.2","TLSv1.3"]
  ciphers                = ["AES256-SHA256", "AES128-GCM-SHA256","TLS_AES_256_GCM_SHA384"]
}
