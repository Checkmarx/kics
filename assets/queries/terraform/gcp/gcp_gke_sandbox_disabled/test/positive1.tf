resource "google_container_cluster" "fail_cluster_no_sandbox" {
  name     = "cluster-fail"
  location = "us-central1"

  node_config {
    machine_type = "e2-medium"
    # FAIL: Missing sandbox_config
  }
}