resource "alicloud_kms_key" "key" {
  description             = "Hello KMS"
  pending_window_in_days  = "7"
  status                  = "Enabled"
}
