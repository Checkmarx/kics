# KICS Rule: IAP Disabled on Backend Service

## Overview

This rule verifies that **Identity-Aware Proxy (IAP)** is enabled in `google_compute_backend_service` resources.

IAP is a Zero Trust security component that intercepts web requests sent to your application, authenticates the user via their Google identity, and only allows the request through if the user is authorized.

**Note on Firewall (Manual):**
Enabling IAP is only the first step. To fully comply with the security policy ("Allow only Google traffic"), you must manually configure your VPC firewall rules to allow traffic **only** from Google load balancer IP ranges (`130.211.0.0/22` and `35.191.0.0/16`) to your instances, blocking all direct traffic from the Internet.

## Rule Logic

The policy audits the `google_compute_backend_service` resource:
1.  Verifies whether the `iap` configuration block exists.
2.  If the block does not exist, the service is considered unprotected by identity.
3.  Verifies that, if the block exists, the required credentials (`oauth2_client_id` and `oauth2_client_secret`) are defined.

## Detected Failure Cases

### Case 1: IAP Disabled

* **Description:** The backend service has been defined without the `iap` block, meaning traffic arrives directly (or through the standard LB) without prior identity verification by IAP.
* **Alert Location:** `google_compute_backend_service` resource.

### Case 2: Missing OAuth Client ID

* **Description:** The `iap` block is present but omits the `oauth2_client_id`, preventing authentication.
* **Alert Location:** `iap` block.

### Case 3: Missing OAuth Client Secret

* **Description:** The `iap` block is present but omits the `oauth2_client_secret`, preventing authentication.
* **Alert Location:** `iap` block.

## Resource Involved

* `google_compute_backend_service`

## Solution

Define the `iap` block within the backend service and include the required OAuth credentials.

```terraform
resource "google_compute_backend_service" "secure" {
  name          = "iap-backend-service"
  health_checks = [google_compute_health_check.default.id]

  iap {
    oauth2_client_id     = "abc-123.apps.googleusercontent.com"
    oauth2_client_secret = "secret-key"
  }
}
