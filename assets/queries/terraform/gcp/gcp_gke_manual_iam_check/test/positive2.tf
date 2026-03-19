resource "google_container_node_pool" "audit_pool" {
  name    = "custom-sa-pool"
  cluster = "my-cluster"

  node_config {
    # INFO: Esta cuenta requiere revisión manual de IAM
    service_account = "dedicated-pool-sa@project.iam.gserviceaccount.com"
  }
}