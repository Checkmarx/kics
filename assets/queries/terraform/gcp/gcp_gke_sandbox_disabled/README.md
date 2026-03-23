# KICS Rule: GKE Sandbox (gVisor) Disabled

## Overview

This **LOW** severity rule verifies whether GKE node pools have **GKE Sandbox (gVisor)** enabled for enhanced isolation.

GKE Sandbox uses **gVisor**, a user-space kernel that provides an additional security barrier between applications and the host kernel. By intercepting and filtering system calls, gVisor mitigates the risk of container escape attacks, where a malicious process attempts to compromise the underlying node. Although gVisor introduces a slight performance overhead, omitting it in environments that run untrusted code or multi-tenant applications is an **Insecure Configuration**.

## Rule Logic

The policy audits the `google_container_cluster` and `google_container_node_pool` resources:
1.  **Block Omission:** Detects if `sandbox_config` is not present in `node_config`.
2.  **Incorrect Type:** Verifies that `sandbox_type` is explicitly `"gvisor"`.

## Detected Failure Cases

---

### Case 1: Sandbox Not Configured in Cluster
* **Description:** The cluster's default nodes do not use gVisor isolation.
* **Alert Location:** `node_config` attribute.

### Case 2: Sandbox Not Configured in Node Pool
* **Description:** An additional node pool has been created that lacks Sandbox protection.
* **Alert Location:** `node_config` attribute.

### Case 3: Insecure Sandbox Type
* **Description:** The block is defined but a value other than `gvisor` is used, disabling the intended protection.
* **Alert Location:** `sandbox_type` attribute.

## Resources Involved

* `google_container_cluster`
* `google_container_node_pool`

## Solution

Enable gVisor ensuring the compatible `COS_CONTAINERD` image type is used.

```terraform
resource "google_container_node_pool" "secure_pool" {
  name    = "untrusted-code-pool"
  cluster = google_container_cluster.primary.name

  node_config {
    image_type = "COS_CONTAINERD"

    sandbox_config {
      sandbox_type = "gvisor"
    }
  }
}
