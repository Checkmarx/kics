resource "alicloud_nas_file_system" "foo" {
  protocol_type = "NFS"
  storage_type  = "Performance"
  description   = "tf-testAccNasConfig"
  encrypt_type  = "2"
  kms_key_id = "1234abcd-12ab-34cd-56ef-1234567890ab"
}
