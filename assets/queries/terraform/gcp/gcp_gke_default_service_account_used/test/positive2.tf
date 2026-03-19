resource "google_container_node_pool" "fail_pool" {
  name       = "insecure-pool"
  cluster    = "some-cluster"
  
  node_config {
    # FALLO: Falta service_account
    preemptible = true
  }
}