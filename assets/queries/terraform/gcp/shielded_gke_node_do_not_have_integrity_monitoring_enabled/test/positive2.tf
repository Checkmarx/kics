resource "google_container_node_pool" "positive2" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.primary.id
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

   shielded_instance_config {
     enable_integrity_monitoring = false
   }
  }
}