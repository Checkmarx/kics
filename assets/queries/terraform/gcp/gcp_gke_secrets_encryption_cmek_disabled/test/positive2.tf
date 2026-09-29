resource "google_container_cluster" "fail_decrypted" {
  name     = "explicit-decrypted"
  
  database_encryption {
    state    = "DECRYPTED" # FALLO: Debe ser ENCRYPTED
    key_name = ""
  }
}