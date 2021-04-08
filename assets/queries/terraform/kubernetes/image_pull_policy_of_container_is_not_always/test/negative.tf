resource "kubernetes_pod" "busybox" {
  metadata {
    name = "busybox-tf"
  }

  spec {
    container {
      image   = "busybox"
      command = ["sleep", "3600"]
      name    = "busybox"

      image_pull_policy = "Always"
    }

    restart_policy = "Always"
  }
}
