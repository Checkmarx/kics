# KICS Rule: GCP HTTP(S) Load Balancer Logging Disabled

## Overview

This **MEDIUM** severity rule verifies that access logging (Logging) is enabled in `google_compute_backend_service` resources in Google Cloud.

Backend Services manage the traffic that the HTTP(S) load balancer distributes to instance groups or buckets. Enabling Cloud Armor and load balancer logs allows capturing critical metadata for each HTTP transaction: source IP address, protocols, response latencies, and status codes (2xx, 4xx, 5xx). Without these logs, incident response capability for security events (such as DoS attacks or injections) and debugging of infrastructure errors are severely limited.

## Rule Logic

The policy audits the `google_compute_backend_service` resource under two criteria:
1.  **Omission:** Detects if the `log_config` block has not been defined.
2.  **Disabling:** Detects if the `enable` attribute within `log_config` has the boolean value `false`.

## Detected Failure Cases

---

### Case 1: Missing Logging Configuration
* **Description:** The backend service is created without logging parameters, which disables traffic telemetry by default.
* **Alert Location:** `google_compute_backend_service` resource level.

### Case 2: Logging Explicitly Disabled
* **Description:** The configuration block is defined but the log service is turned off.
* **Alert Location:** `enable` attribute within `log_config`.

## Resource Involved

* `google_compute_backend_service`

## Solution

Add the `log_config` block with the `enable = true` parameter. A `sample_rate` of `1.0` is recommended for production.

```terraform
resource "google_compute_backend_service" "compliant_service" {
  name        = "web-backend-service"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 10

  # Technical solution
  log_config {
    enable      = true
    sample_rate = 1.0
  }
}
