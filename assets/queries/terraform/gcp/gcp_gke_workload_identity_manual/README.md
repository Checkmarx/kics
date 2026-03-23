# KICS Rule: GKE Workload Identity & Dedicated SA (Manual)

## Overview

This informational (**INFO**) **Access Control** rule audits the identity configuration for workloads running in **Google Kubernetes Engine (GKE)**.

The security best practice for GKE applications to access Google Cloud services (such as Cloud Storage or BigQuery) is to use **Workload Identity**. This functionality eliminates the need to download and manage JSON service account keys by securely binding a Kubernetes Service Account (KSA) with a Google Service Account (GSA).

However, enabling the feature is only half the work. A secure configuration requires a **1:1** mapping; if multiple applications share the same Google identity, a compromise in one of them would grant lateral access to the resources of the others.

## Rule Logic

The policy audits the `google_container_cluster` resource in two phases:
1.  **Feature Validation:** Detects if `workload_identity_config` is absent, which forces Pods to use the node identity (high risk).
2.  **Governance Audit:** If the feature is active, it alerts the auditor to manually verify in the code that each microservice has its own dedicated binding.

## Detected Failure Cases

---

### Case 1: Workload Identity Disabled
* **Description:** The cluster lacks the infrastructure necessary for granular identities.
* **Alert Location:** `google_container_cluster` resource level.

### Case 2: Identity Mapping Review
* **Description:** The functionality is active, but it must be confirmed that service accounts are not being shared between different microservices.
* **Alert Location:** `workload_identity_config` block.

## Resource Involved

* `google_container_cluster`

## Solution

1.  Enable Workload Identity in your cluster resource.
2.  Implement granular bindings using the `roles/iam.workloadIdentityUser` role.

```terraform
resource "google_container_cluster" "compliant_cluster" {
  name     = "secure-cluster"
  location = "us-central1"

  # Enable the feature
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# Example of manual binding to verify (1:1 Mapping)
resource "google_service_account_iam_member" "dedicated_binding" {
  service_account_id = google_service_account.app_specific_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[namespace/ksa-name]"
}
