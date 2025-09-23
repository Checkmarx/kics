
resource "kubernetes_pod" "positive1" {
  metadata {
    name = "terraform-example"
  }

  spec {
   container {
    image = "nginx:1.7.9"
    name  = "example1"

    security_context {
      capabilities {
      }
    }

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

   container {
    image = "nginx:1.7.9"
    name  = "example11"

    security_context {
      capabilities {
      }
    }

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

   container {
    image = "nginx:1.7.9"
    name  = "example2"

    security_context {
      capabilities {
        drop = ["NET_BIND_SERVICE"]
      }
    }

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

   container {
    image = "nginx:1.7.9"
    name  = "example22"

    security_context {
      capabilities {
        drop = ["NET_BIND_SERVICE"]
      }
    }

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

   container {
    image = "nginx:1.7.9"
    name  = "example3"

    security_context {
      read_only_root_filesystem = true
    }

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

   container {
    image = "nginx:1.7.9"
    name  = "example33"

    security_context {
      read_only_root_filesystem = true
    }

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

   container {
    image = "nginx:1.7.9"
    name  = "example4"

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

   container {
    image = "nginx:1.7.9"
    name  = "example44"

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

resource "kubernetes_pod" "positive2" {
  metadata {
    name = "terraform-example"
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"

      security_context {
        capabilities {
        }
      }

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

resource "kubernetes_pod" "positive3" {
  metadata {
    name = "terraform-example"
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"

      security_context {
        capabilities {
          drop = ["NET_BIND_SERVICE"]
        }
      }

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

resource "kubernetes_pod" "positive4" {
  metadata {
    name = "terraform-example"
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "example"

      security_context {
      }

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

resource "kubernetes_pod" "positive5" {
  metadata {
    name = "terraform-example"
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
