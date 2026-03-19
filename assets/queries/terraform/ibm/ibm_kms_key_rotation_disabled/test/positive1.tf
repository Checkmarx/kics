resource "ibm_kms_key" "key_no_policy" {
  instance_id  = "guid-123"
  key_name     = "key-fails-1"
  standard_key = false
}