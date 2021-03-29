resource "kubernetes_role" "example1" {
  metadata {
    name = "terraform-example1"
    labels = {
      test = "MyRole"
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["secrets", "namespaces"]
    resource_names = ["foo"]
    verbs          = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role" "example2" {
  metadata {
    name = "terraform-example2"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "secrets"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list"]
  }
}
