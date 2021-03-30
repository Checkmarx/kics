resource "kubernetes_role" "example1" {
  metadata {
    name = "terraform-example1"
    labels = {
      test = "MyRole"
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["pods"]
    resource_names = ["foo"]
    verbs          = ["create", "list", "watch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_role" "example2" {
  metadata {
    name = "terraform-example2"
    labels = {
      test = "MyRole"
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["*"]
    resource_names = ["foo"]
    verbs          = ["create", "list", "watch"]
  }
}

resource "kubernetes_role" "example3" {
  metadata {
    name = "terraform-example3"
    labels = {
      test = "MyRole"
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["pods"]
    resource_names = ["foo"]
    verbs          = ["*", "list", "watch"]
  }
}

resource "kubernetes_role" "example4" {
  metadata {
    name = "terraform-example4"
    labels = {
      test = "MyRole"
    }
  }

  rule {
    api_groups     = [""]
    resources      = ["*"]
    resource_names = ["foo"]
    verbs          = ["*", "list", "watch"]
  }
}
