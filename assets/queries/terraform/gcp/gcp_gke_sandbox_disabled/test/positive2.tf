resource "google_container_node_pool" "fail_pool_no_sandbox" {
  name    = "pool-fail"
  cluster = "my-cluster"

  node_config {
    machine_type = "e2-medium"
    # FALLO: Falta sandbox_config
  }
}