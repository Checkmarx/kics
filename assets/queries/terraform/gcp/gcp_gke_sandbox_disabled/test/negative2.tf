# Caso Negativo 2: Configuración correcta en un pool de nodos independiente
resource "google_container_node_pool" "pass_pool" {
  name    = "secure-untrusted-pool"
  cluster = "my-cluster"

  node_config {
    image_type = "COS_CONTAINERD"
    sandbox_config {
      sandbox_type = "gvisor"
    }
  }
}