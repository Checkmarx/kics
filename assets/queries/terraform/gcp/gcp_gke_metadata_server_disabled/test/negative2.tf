resource "google_container_node_pool" "pass_pool" {
  name    = "secure-pool"
  cluster = "my-cluster"
  node_config {
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}