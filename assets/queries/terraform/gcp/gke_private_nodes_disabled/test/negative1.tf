resource "google_container_cluster" "pass" {
  name     = "my-gke-cluster"
  location = "us-central1"

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
}
