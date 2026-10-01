resource "google_container_cluster" "pass_cluster" {
  name = "secure-cluster"
  node_config {
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}