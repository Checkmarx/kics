---
title: Metadata Label Is Invalid
hide:
  toc: true
  navigation: true
---

<style>
  .highlight .hll {
    background-color: #ff171742;
  }
  .md-content {
    max-width: 1100px;
    margin: 0 auto;
  }
</style>

-   **Query id:** bc3dabb6-fd50-40f8-b9ba-7429c9f1fb0e
-   **Query name:** Metadata Label Is Invalid
-   **Platform:** Terraform
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Best Practices
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/710.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/710.html')">710</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/kubernetes/metadata_label_is_invalid)

### Description
Check if any label in the metadata is invalid.<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod#labels)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="5"
resource "kubernetes_pod" "test" {
  metadata {
    name = "terraform-example"

    labels = {
      app = "g**dy.l+bel"
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

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "kubernetes_pod" "test2" {
  metadata {
    name = "terraform-example"

    labels = {
      app = "MyApp"
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

```
