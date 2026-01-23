resource "google_container_cluster" "positive" {
  name               = "pud-example-rg"
  location           = "us-central1-a"
  enable_kubernetes_alpha = true
}