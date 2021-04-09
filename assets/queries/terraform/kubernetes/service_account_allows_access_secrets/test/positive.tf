# Cluster Role
resource "kubernetes_cluster_role" "cluster_role_name" {
  metadata {
    name = "terraform-example-1"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces", "pods", "secrets"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "terraform-example-2"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster_role_name"
  }
  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "kube-system"
  }
  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
}

# Role
resource "kubernetes_role" "role_name" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyRole"
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["pods"]
    resource_names = ["foo"]
    verbs          = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list"]
  }
   rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "example" {
  metadata {
    name      = "terraform-example"
    namespace = "default"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "role_name"
  }
  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "kube-system"
  }
  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
}
