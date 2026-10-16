resource "google_container_cluster" "pass" {
  name     = "my-gke-cluster"
  location = "us-central1"

  binary_authorization {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }
}
