resource "google_container_cluster" "fail_block_missing" {
  name     = "cluster-without-posture"
  location = "us-central1"
  # FALLO: Falta security_posture_config
}