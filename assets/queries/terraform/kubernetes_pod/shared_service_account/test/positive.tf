resource "kubernetes_pod" "with_pod_affinity" {
  metadata {
    name = "with-pod-affinity"
  }

  spec {
    affinity {
      pod_affinity {
        required_during_scheduling_ignored_during_execution {
          label_selector {
            match_expressions {
              key      = "security"
              operator = "In"
              values   = ["S1"]
            }
          }

          topology_key = "failure-domain.beta.kubernetes.io/zone"
        }
      }

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
      name  = "with-pod-affinity"
      image = "k8s.gcr.io/pause:2.0"
    }

    service_account_name = "terraform-example"
  }
}

resource "kubernetes_service_account" "terraform-example" {
  metadata {
    name = "terraform-example"
  }
  secret {
    name = kubernetes_secret.example.metadata.0.name
  }
}

resource "kubernetes_secret" "example" {
  metadata {
    name = "terraform-example"
  }
}
