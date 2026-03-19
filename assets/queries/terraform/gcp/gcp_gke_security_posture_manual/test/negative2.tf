resource "google_container_cluster" "pass_enterprise" {
  name = "secure-cluster-enterprise"
  security_posture_config {
    mode = "ENTERPRISE"
  }
}