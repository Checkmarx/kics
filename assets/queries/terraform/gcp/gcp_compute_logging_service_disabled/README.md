# KICS Rule: GCP Compute Logging Service Disabled

## Overview

This **Observability** rule verifies that **Google Compute Engine** instances (`google_compute_instance`) have logging to the **Cloud Logging** service enabled via the `google-logging-enabled` metadata key.

Visibility is a critical security component. The Google Cloud agent (Ops Agent) uses this flag to determine whether to transmit operating system and application logs to the centralized Google Cloud console. Without these logs, intrusion detection, forensic analysis, and resolution of operational errors become impractical tasks.

## Rule Logic

The policy audits the resource by evaluating three possible failure states to maximize reporting accuracy:
1.  **Missing Block:** If the entire `metadata` block is absent.
2.  **Missing Key:** If the `metadata` block exists but does not define the required key.
3.  **Incorrect Value:** If the key exists but has been explicitly set to `"false"`.

## Detected Failure Cases

---

### Case 1: Missing Metadata Configuration
* **Description:** The instance does not define any metadata, therefore omitting the logging service.
* **Alert Location:** `google_compute_instance` resource level.

### Case 2: Missing Logging Flag
* **Description:** Metadata is used but `google-logging-enabled` is specifically omitted.
* **Alert Location:** `metadata` attribute.

### Case 3: Logging Disabled
* **Description:** The value `"false"` has been configured, actively blocking log ingestion.
* **Alert Location:** `google-logging-enabled` attribute.

## Resource Involved

* `google_compute_instance`

## Solution

Ensure the metadata is set to `"true"` to enable the service.

```terraform
resource "google_compute_instance" "secure_vm" {
  name         = "prod-server"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  metadata = {
    "google-logging-enabled" = "true"
  }
}
