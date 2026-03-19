resource "google_container_node_pool" "fail_pool_no_block" {
  name    = "pool-missing-metadata-config"
  cluster = "my-cluster"

  node_config {
    preemptible = true
    # FALLO: No existe workload_metadata_config
  }
}