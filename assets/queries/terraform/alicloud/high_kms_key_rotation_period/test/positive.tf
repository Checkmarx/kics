resource "alicloud_kms_key" "keypos1" {
  description             = "Hello KMS"
  pending_window_in_days  = "7"
  status                  = "Enabled"
  automatic_rotation      = "Disabled"
}
