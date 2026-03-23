# KICS Rule: GKE Metadata Server Disabled

## Overview

This **HIGH** severity rule verifies that GKE nodes use the **GKE Metadata Server** to manage workload identities.

By default, GKE nodes have access to the Compute Engine (GCE) metadata server, which exposes sensitive host information and node service account access tokens. If an attacker manages to compromise a pod, they could query this endpoint to obtain credentials and perform lateral movement to other project resources. By enabling `GKE_METADATA`, the bridge to **Workload Identity** is activated, intercepting these requests and limiting access to only what the Pod is specifically permitted.

## Rule Logic

The policy audits the `google_container_cluster` and `google_container_node_pool` resources under two criteria:
1.  **Block Omission:** Verifies if `workload_metadata_config` is present within `node_config`.
2.  **Insecure Mode:** Ensures that the `mode` attribute is strictly `GKE_METADATA`. The value `GCE_METADATA` (legacy default value) is considered vulnerable.

## Detected Failure Cases

---

### Case 1: Missing Metadata Configuration
* **Description:** The cluster or node pool does not define the workload metadata mode.
* **Alert Location:** `node_config` attribute.

### Case 2: Use of GCE_METADATA (Legacy/Vulnerable)
* **Description:** Pods are explicitly allowed access to the underlying compute instance metadata.
* **Alert Location:** `mode` attribute within `workload_metadata_config`.

## Resources Involved

* `google_container_cluster`
* `google_container_node_pool`

## Solution

Configure the `workload_metadata_config` block with the `GKE_METADATA` mode.

```terraform
resource "google_container_node_pool" "compliant_pool" {
  name    = "secure-pool"
  cluster = google_container_cluster.primary.name

  node_config {
    # Technical solution
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
