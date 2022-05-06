resource "alicloud_nas_file_system" "foopos" {
  protocol_type = "NFS"
  storage_type  = "Performance"
  description   = "tf-testAccNasConfig"
  encrypt_type  = "0"
}
