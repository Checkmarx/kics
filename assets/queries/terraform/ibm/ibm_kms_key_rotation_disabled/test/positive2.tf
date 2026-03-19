resource "ibm_kms_key" "key_empty_policy" {
  instance_id  = "guid-123"
  key_name     = "key-fails-2"
  standard_key = false
  
  rotation_policy {
    # Falta rotation_interval_month
  }
}