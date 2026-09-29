resource "google_container_cluster" "fail_cluster_wrong_mode" {
  name = "cluster-gce-mode"
  
  node_config {
    workload_metadata_config {
      mode = "GCE_METADATA" # FALLO: Debe ser GKE_METADATA
    }
  }
}