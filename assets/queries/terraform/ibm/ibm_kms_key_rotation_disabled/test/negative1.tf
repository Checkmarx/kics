resource "ibm_kms_key" "key_secure" {
  instance_id  = "guid-123"
  key_name     = "key-compliant"
  standard_key = false
  
  rotation_policy {
    rotation_interval_month = 12
  }
}