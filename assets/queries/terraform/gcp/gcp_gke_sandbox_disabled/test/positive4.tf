resource "google_container_node_pool" "fail_pool_wrong_type" {
  name    = "pool-wrong-type"
  cluster = "my-cluster"

  node_config {
    sandbox_config {
      sandbox_type = "disabled" # FALLO: Debe ser gvisor
    }
  }
}