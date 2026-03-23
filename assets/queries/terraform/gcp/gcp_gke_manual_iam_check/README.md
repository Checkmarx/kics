# KICS Rule: GKE Service Account IAM Review (Manual)

## Overview

This informational (INFO) **Supply Chain** rule audits the identities used by **Google Kubernetes Engine (GKE)** nodes when custom service accounts have been configured.

Using custom service accounts is the first step toward the principle of least privilege. However, if this account is assigned roles with write permissions (such as `roles/artifactregistry.writer` or `roles/storage.objectAdmin`), an attacker who compromises a node could modify or replace container images in the registry. This would enable persistence or privilege escalation attacks in other clusters that consume those same images.

## Rule Logic

The policy identifies `google_container_cluster` and `google_container_node_pool` resources that explicitly define a `service_account`. As a manual check, it generates an informational alert on the service account line so the auditor can validate in the GCP project that the associated roles are exclusively **Read-Only**.

## Detected Failure Cases

---

### Case 1: SA Review in Cluster
* **Description:** A custom identity has been defined for the cluster. It must be verified that it does not have "Push" permissions to the image registry.
* **Alert Location:** `service_account` attribute in `google_container_cluster`.

### Case 2: SA Review in Node Pool
* **Description:** A specific node pool uses its own identity that requires IAM role auditing.
* **Alert Location:** `service_account` attribute in `google_container_node_pool`.

## Resources Involved

* `google_container_cluster`
* `google_container_node_pool`

## Solution

Ensure that the assigned Service Account only has read roles for the image registry used.

**Recommended Roles:**
* `roles/artifactregistry.reader` (for Artifact Registry)
* `roles/storage.objectViewer` (for Container Registry/GCR)
* `roles/logging.logWriter`
* `roles/monitoring.metricWriter`
