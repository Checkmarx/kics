resource "google_container_cluster" "fail_decrypted" {
  name     = "explicit-decrypted"
  
  database_encryption {
    state    = "DECRYPTED" # FAIL: Should be ENCRYPTED
    key_name = ""
  }
}