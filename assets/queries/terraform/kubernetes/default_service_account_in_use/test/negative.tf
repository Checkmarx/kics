resource "kubernetes_service_account" "example3" {
  metadata {
    name = "default"
  }

  automount_service_account_token = false
}
