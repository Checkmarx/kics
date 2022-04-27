resource "alicloud_kms_key" "keypos1" {
  description             = "Hello KMS"
  pending_window_in_days  = "7"
  status                  = "Enabled"
  automatic_rotation      = "Enabled"
  rotation_interval      = "31536010s"
}
