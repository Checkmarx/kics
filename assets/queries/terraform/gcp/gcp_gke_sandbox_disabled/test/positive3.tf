resource "google_container_cluster" "fail_cluster_wrong_type" {
  name = "cluster-wrong-type"
  
  node_config {
    sandbox_config {
      sandbox_type = "other_runtime" # FAIL: Should be gvisor
    }
  }
}