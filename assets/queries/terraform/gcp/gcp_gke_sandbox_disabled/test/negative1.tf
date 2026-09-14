# Caso Negativo 1: Configuración correcta en un clúster principal
resource "google_container_cluster" "pass_cluster" {
  name     = "secure-main-cluster"
  location = "us-central1"

  node_config {
    image_type = "COS_CONTAINERD"
    sandbox_config {
      sandbox_type = "gvisor"
    }
  }
}