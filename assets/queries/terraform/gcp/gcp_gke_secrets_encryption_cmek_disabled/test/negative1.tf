resource "google_container_cluster" "pass_encrypted" {
  name     = "secure-cluster"
  
  database_encryption {
    state    = "ENCRYPTED"
    key_name = "projects/p1/locations/global/keyRings/r1/cryptoKeys/k1"
  }
}