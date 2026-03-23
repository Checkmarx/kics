# KICS Rule: GKE Default Service Account Used

## Overview

This **HIGH** severity rule verifies that **Google Kubernetes Engine (GKE)** clusters and node pools do not use the default Compute Engine service account.

By default, if the `service_account` attribute is not specified, GKE uses the project's default service account (`PROJECT_NUMBER-compute@developer.gserviceaccount.com`). This account automatically has the **Editor** role, which grants nodes (and potentially Pods) extensive permissions to modify resources in GCP, such as storage buckets, VPC networks, and other instances. Using a dedicated service account with minimal privileges drastically reduces the "blast radius" in the event of a security compromise in the cluster.

## Rule Logic

The policy audits the `google_container_cluster` and `google_container_node_pool` resources under the following criteria:
1.  **Missing Attribute:** Identifies if the `node_config` block lacks the `service_account` key.
2.  **Risk Identification:** The alert is triggered upon detecting that the cluster will delegate its identity to the project's most privileged service account by default.

## Detected Failure Cases

---

### Case 1: Implicit Use in Cluster
* **Description:** A GKE cluster is defined without specifying an identity for the nodes.
* **Alert Location:** `node_config` attribute of the `google_container_cluster` resource.

### Case 2: Implicit Use in Node Pool
* **Description:** An additional node pool is created that inherits the default service account.
* **Alert Location:** `node_config` attribute of the `google_container_node_pool` resource.

## Resources Involved

* `google_container_cluster`
* `google_container_node_pool`

## Solution

Create a custom Service Account with the minimum necessary permissions (e.g., logging, monitoring, and registry access roles) and assign it explicitly.

```terraform
resource "google_service_account" "gke_nodes_sa" {
  account_id   = "gke-nodes-identity"
  display_name = "GKE Nodes Minimal Service Account"
}

resource "google_container_cluster" "secure_cluster" {
  name     = "production-cluster"
  location = "us-central1"

  node_config {
    # Solution: Dedicated identity
    service_account = google_service_account.gke_nodes_sa.email
    oauth_scopes    = ["[https://www.googleapis.com/auth/cloud-platform](https://www.googleapis.com/auth/cloud-platform)"]
  }
}
