resource "google_container_cluster" "pass_cluster" {
  name = "secure-cluster"
  node_config {
    service_account = "dedicated-sa@project.iam.gserviceaccount.com"
  }
}