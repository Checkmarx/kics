---
title: Image Pull Policy Of The Container Is Not Set To Always
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

-   **Query id:** aa737abf-6b1d-4aba-95aa-5c160bd7f96e
-   **Query name:** Image Pull Policy Of The Container Is Not Set To Always
-   **Platform:** Terraform
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Insecure Configurations
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/665.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/665.html')">665</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/kubernetes/image_pull_policy_of_container_is_not_always)

### Description
Image Pull Policy of the container must be defined and set to Always<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/pod#image_pull_policy)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="12"
resource "kubernetes_pod" "busybox" {
  metadata {
    name = "busybox-tf"
  }

  spec {
    container {
      image   = "busybox"
      command = ["sleep", "3600"]
      name    = "busybox"

      image_pull_policy = "IfNotPresent"
    }

    restart_policy = "Always"
  }
}

```
```tf title="Positive test num. 2 - tf file" hl_lines="30"

resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image             = "nginx:1.7.8"
          name              = "example"
          image_pull_policy = "IfNotPresent"

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
        }
      }
    }
  }
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
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

```
