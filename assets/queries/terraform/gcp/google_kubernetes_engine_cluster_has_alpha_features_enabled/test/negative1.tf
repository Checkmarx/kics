resource "google_container_cluster" "negative1" {
  name               = "pud-example-rg"
  location           = "us-central1-a"
  enable_kubernetes_alpha = false
}