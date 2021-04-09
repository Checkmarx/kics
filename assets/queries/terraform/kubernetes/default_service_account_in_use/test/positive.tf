resource "kubernetes_service_account" "example" {
  metadata {
    name = "default"
  }
}

resource "kubernetes_service_account" "example2" {
  metadata {
    name = "default"
  }

  automount_service_account_token = true
}
