resource "kubernetes_deployment" "example3" {
  metadata {
    name = "terraform-example"
    labels = {
      k8s-app = "prometheus"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        k8s-app = "prometheus"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "prometheus"
        }
      }

      spec {
        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                label_selector {
                  match_expressions {
                    key      = "security"
                    operator = "In"
                    values   = ["S2"]
                  }
                }

                topology_key = "failure-domain.beta.kubernetes.io/zone"
              }
            }
         }
        }

        container {
          image = "nginx:1.7.8"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
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
      }
    }
  }
}
