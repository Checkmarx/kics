resource "google_container_node_pool" "fail_pool_wrong_mode" {
  name    = "pool-gce-mode"
  cluster = "my-cluster"

  node_config {
    workload_metadata_config {
      mode = "GCE_METADATA" # FALLO: Debe ser GKE_METADATA
    }
  }
}