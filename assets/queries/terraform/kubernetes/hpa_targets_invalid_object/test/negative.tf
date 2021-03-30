resource "kubernetes_horizontal_pod_autoscaler" "example5" {
  metadata {
    name = "test"
  }

  spec {
    min_replicas = 50
    max_replicas = 100

    scale_target_ref {
      kind = "Deployment"
      name = "MyApp"
    }

    metric {
      type = "Object"
      object {
        metric {
          name = "latency"
        }
        described_object {
          name = "main-route"
          api_version = "networking.k8s.io/v1beta1"
          kind = "Ingress"
        }
        target {
          type  = "Value"
          value = "100"
        }
      }
    }
  }
}
