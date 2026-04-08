---
title: Beta - Kubernetes Web UI Is Not Disabled
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

-   **Query id:** ced11de2-e701-4e63-83ab-4fdb1ab8c5dd
-   **Query name:** Beta - Kubernetes Web UI Is Not Disabled
-   **Platform:** Terraform
-   **Severity:** <span style="color:#edd57e">Low</span>
-   **Category:** Insecure Configurations
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/1188.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/1188.html')">1188</a>
-   **Risk score:** <span style="color:#edd57e">1.0</span>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/gcp/kubernetes_web_ui_is_not_disabled)

### Description
Kubernetes Web UI (Dashboard) should be disabled when running on Kubernetes Engine<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/google/2.20.3/docs/resources/container_cluster#kubernetes_dashboard-4)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="8"
resource "google_container_cluster" "positive1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  addons_config {
    kubernetes_dashboard {
        disabled = false
    }
  }
}
```
```tf title="Positive test num. 2 - tf file" hl_lines="1"
resource "google_container_cluster" "positive2" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.8.12-gke.2" # gke version lower than 1.10
}
```
```tf title="Positive test num. 3 - tf file" hl_lines="6"
resource "google_container_cluster" "positive3" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.8.12-gke.2" # gke version lower than 1.10
  addons_config {}
}
```
<details><summary>Positive test num. 4 - tf file</summary>

```tf hl_lines="8"
resource "google_container_cluster" "positive4" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.8.12-gke.2" # gke version lower than 1.10
  addons_config {
    kubernetes_dashboard {
        disabled = false
    }
  }
}
```
</details>
<details><summary>Positive test num. 5 - tf file</summary>

```tf hl_lines="9"
resource "google_container_cluster" "positive5" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.11.8-gke.5" # gke version higher than 1.10

  addons_config {
    kubernetes_dashboard {
        disabled = false
    }
  }
}
```
</details>


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "google_container_cluster" "negative1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
}
```
```tf title="Negative test num. 2 - tf file"
resource "google_container_cluster" "negative2" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  addons_config {}
}
```
```tf title="Negative test num. 3 - tf file"
resource "google_container_cluster" "negative3" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  addons_config {
    kubernetes_dashboard {
        disabled = true
    }
  }
}
```
<details><summary>Negative test num. 4 - tf file</summary>

```tf
resource "google_container_cluster" "negative4" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.8.12-gke.2" # gke version lower than 1.10
  addons_config {
    kubernetes_dashboard {
        disabled = true
    }
  }
}
```
</details>
<details><summary>Negative test num. 5 - tf file</summary>

```tf
resource "google_container_cluster" "negative5" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.11.8-gke.5" # gke version higher than 1.10
}
```
</details>
<details><summary>Negative test num. 6 - tf file</summary>

```tf
resource "google_container_cluster" "negative6" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.11.8-gke.5" # gke version higher than 1.10

  addons_config {}
}
```
</details>
<details><summary>Negative test num. 7 - tf file</summary>

```tf
resource "google_container_cluster" "negative7" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  min_master_version = "1.11.8-gke.5" # gke version higher than 1.10

  addons_config {
    kubernetes_dashboard {
        disabled = true
    }
  }
}
```
</details>

