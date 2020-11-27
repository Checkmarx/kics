resource "kubernetes_pod" "test" {
  metadata {
    name = "terraform-example"
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"

      resources {
        requests {
          memory = "100Mi"
        }
      }
    }
  }
}