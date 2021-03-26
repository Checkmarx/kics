resource "kubernetes_service_account" "example" {
  metadata {
    name = "default"
  }
}
