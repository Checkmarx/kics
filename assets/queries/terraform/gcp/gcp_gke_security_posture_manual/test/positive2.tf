resource "google_container_cluster" "fail_mode_disabled" {
  name = "cluster-posture-off"
  
  security_posture_config {
    mode = "DISABLED" # FALLO: Debe ser BASIC o ENTERPRISE
  }
}