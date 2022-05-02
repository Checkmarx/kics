resource "alicloud_nas_file_system" "foopos2" {
  protocol_type = "NFS"
  storage_type  = "Performance"
  description   = "tf-testAccNasConfig"
}
