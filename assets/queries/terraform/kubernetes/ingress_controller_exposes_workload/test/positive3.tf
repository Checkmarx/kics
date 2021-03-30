resource "kubernetes_service" "example-4" {
  metadata {
    name = "ingress-service-4"
  }
  spec {
    port {
      port = 80
      target_port = 80
      protocol = "TCP"
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress" "example-4" {
  wait_for_load_balancer = true
  metadata {
    name = "example-4"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/rule1*"
          backend {
            service_name = "example-4"
            service_port = 80
          }
        }
      }
    }
    rule {
      http {
        path {
          path = "/rule2*"
          backend {
            service_name = "service"
            service_port = 80
          }
        }
      }
    }
  }
}
