resource "google_container_cluster" "fail_missing_key" {
  name     = "encrypted-no-key"
  
  # FALLO: Falta key_name
  database_encryption {
    state    = "ENCRYPTED"
  }
}