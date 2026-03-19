resource "google_container_cluster" "audit_cluster" {
  name     = "custom-sa-cluster"
  location = "us-central1"

  node_config {
    # INFO: Esta cuenta requiere revisión manual de IAM
    service_account = "gke-nodes-custom@project.iam.gserviceaccount.com"
  }
}