resource "kubernetes_cluster_role" "example1" {
  metadata {
    name = "terraform-example1"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods"]
    verbs      = ["create", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "example2" {
  metadata {
    name = "terraform-example2"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "*"]
    verbs      = ["create", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "example3" {
  metadata {
    name = "terraform-example3"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "*"]
    verbs      = ["*", "list", "watch"]
  }
}

resource "kubernetes_cluster_role" "example4" {
  metadata {
    name = "terraform-example4"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods"]
    verbs      = ["*", "list", "watch"]
  }
}
