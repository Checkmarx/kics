resource "kubernetes_pod" "test" {
  metadata {
    name = "terraform-example"
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"

      security_context {
        capabilities {
          add = ["NET_ADMIN", "SYS_TIME"]
        }
      }
    }
  }
}