---
title: SSH Access Is Not Restricted
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

-   **Query id:** c4dcdcdf-10dd-4bf4-b4a0-8f6239e6aaa0
-   **Query name:** SSH Access Is Not Restricted
-   **Platform:** Terraform
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Networking and Firewall
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/732.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/732.html')">732</a>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/gcp/ssh_access_is_not_restricted)

### Description
Google Firewall should not allow SSH access (port 22) from the Internet (public CIDR block) to ensure the principle of least privileges<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="43 13 31"
resource "google_compute_firewall" "positive1" {
  name    = "test-firewall"
  network = google_compute_network.default.name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}

resource "google_compute_firewall" "positive2" {
  name    = "test-firewall"
  network = google_compute_network.default.name

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000","21-3390"]
  }

  source_tags = ["web"]
}

resource "google_compute_firewall" "positive3" {
  name    = "test-firewall"
  network = google_compute_network.default.name

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "all"
  }

  source_tags = ["web"]
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "google_compute_firewall" "negative1" {
  name    = "test-firewall"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]
}
```
