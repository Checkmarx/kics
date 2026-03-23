# KICS Rule: GKE Security Posture Disabled (Manual)

## Overview

This informational (**INFO**) **Observability** rule verifies whether the GKE **Security Posture Dashboard** is active in the cluster configuration.

The security posture dashboard is a native Google Cloud tool that automatically scans Kubernetes workloads for common misconfigurations and known vulnerabilities in container images. It provides actionable recommendations to improve security without adding operational complexity. Since the availability of this feature may vary depending on the GKE version channel and license type (Standard vs Autopilot), this rule alerts on its absence to allow a manual compatibility check.

## Rule Logic

The policy audits the `google_container_cluster` resource identifying two scenarios:
1.  **Omission:** The `security_posture_config` block is not present in the Terraform code.
2.  **Disabling:** The block exists but the `mode` parameter has been explicitly set to `DISABLED`.

## Detected Failure Cases

---

### Case 1: Missing Posture Configuration
* **Description:** The cluster has not enabled the security control dashboard. It is recommended to verify whether the GKE version allows its activation.
* **Alert Location:** `google_container_cluster` resource level.

### Case 2: Posture Mode Disabled
* **Description:** The security posture has been configured but disabled using the `DISABLED` value.
* **Alert Location:** `mode` attribute within `security_posture_config`.

## Resource Involved

* `google_container_cluster`

## Solution

Enable the security posture by setting the mode to `BASIC` or `ENTERPRISE`.

```terraform
resource "google_container_cluster" "compliant_cluster" {
  name     = "monitored-cluster"
  location = "us-central1"

  # Recommended solution for security observability
  security_posture_config {
    mode               = "BASIC"
    vulnerability_mode = "VULNERABILITY_BASIC"
  }
}
