resource "kubernetes_service" "MyApp2" {
  metadata {
    name = "ingress-service-2"
  }
  spec {
    port {
      port = 80
      target_port = 8080
      protocol = "TCP"
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress" "example-ingress-2" {
  metadata {
    name = "example-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
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

        path {
          backend {
            service_name = "MyApp2"
            service_port = 8080
          }

          path = "/app2/*"
        }
      }
    }

    tls {
      secret_name = "tls-secret"
    }
  }
}
