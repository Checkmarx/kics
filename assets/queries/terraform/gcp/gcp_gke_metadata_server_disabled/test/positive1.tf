resource "google_container_cluster" "fail_cluster_no_block" {
  name     = "cluster-missing-metadata-config"
  location = "us-central1"

  node_config {
    machine_type = "e2-medium"
    # FALLO: No existe workload_metadata_config
  }
}