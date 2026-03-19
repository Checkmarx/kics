resource "google_container_cluster" "pass_basic" {
  name = "secure-cluster-basic"
  security_posture_config {
    mode = "BASIC"
  }
}