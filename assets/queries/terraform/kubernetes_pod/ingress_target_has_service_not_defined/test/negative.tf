resource "kubernetes_ingress" "example_ingress" {
  metadata {
    name = "example-ingress"
  }

  spec {
    backend {
      service_name = "MyApp1"
      service_port = 8080
    }

    rule {
      http {
        path {
          backend {
            service_name = "MyApp1"
            service_port = 8080
          }

          path = "/app1/*"
        }
      }
    }

    tls {
      secret_name = "tls-secret"
    }
  }
}

resource "kubernetes_pod" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      app = "MyApp1"
    }
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"

      port {
        container_port = 8080
      }
    }
  }
}