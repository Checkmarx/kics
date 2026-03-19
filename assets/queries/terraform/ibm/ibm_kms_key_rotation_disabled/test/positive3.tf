resource "ibm_kms_key" "key_zero_policy" {
  instance_id  = "guid-123"
  key_name     = "key-fails-3"
  standard_key = false
  
  rotation_policy {
    rotation_interval_month = 0
  }
}