resource "kubernetes_network_policy" "example2" {
  metadata {
    name      = "terraform-example-network-policy"
    namespace = "default"
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "name"
        operator = "In"
        values   = ["webfront", "api"]
      }
      match_labels = {
            app = "ngnix2"
      }

    }

    ingress {
      ports {
        port     = "http"
        protocol = "TCP"
      }
      ports {
        port     = "8125"
        protocol = "UDP"
      }

      from {
        namespace_selector {
          match_labels = {
            name = "default"
          }
        }
      }

      from {
        ip_block {
          cidr = "10.0.0.0/8"
          except = [
            "10.0.0.0/24",
            "10.0.1.0/24",
          ]
        }
      }
    }

    egress {} # single empty rule to allow all egress traffic

    policy_types = ["Ingress", "Egress"]
  }
}

resource "kubernetes_pod" "test2" {
  metadata {
    name = "terraform-example"

    labels = {
      app = "ngnix2"
    }
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"

      env {
        name  = "environment"
        value = "test"
      }

      port {
        container_port = 8080
      }

      liveness_probe {
        http_get {
          path = "/nginx_status"
          port = 80

          http_header {
            name  = "X-Custom-Header"
            value = "Awesome"
          }
        }

        initial_delay_seconds = 3
        period_seconds        = 3
      }
    }

    dns_config {
      nameservers = ["1.1.1.1", "8.8.8.8", "9.9.9.9"]
      searches    = ["example.com"]

      option {
        name  = "ndots"
        value = 1
      }

      option {
        name = "use-vc"
      }
    }

    dns_policy = "None"
  }
}


resource "kubernetes_network_policy" "example222" {
  metadata {
    name      = "terraform-example-network-policy"
    namespace = "default"
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "name"
        operator = "In"
        values   = ["webfront", "api"]
      }
      match_labels = {
            app = "kubernetes_pod.test2.metadata.0.labels.app"
      }

    }

    ingress {
      ports {
        port     = "http"
        protocol = "TCP"
      }
      ports {
        port     = "8125"
        protocol = "UDP"
      }

      from {
        namespace_selector {
          match_labels = {
            name = "default"
          }
        }
      }

      from {
        ip_block {
          cidr = "10.0.0.0/8"
          except = [
            "10.0.0.0/24",
            "10.0.1.0/24",
          ]
        }
      }
    }

    egress {} # single empty rule to allow all egress traffic

    policy_types = ["Ingress", "Egress"]
  }
}
