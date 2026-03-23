# KICS Rule: Google API Key Restrictions (Manual)

## Overview

This informational (INFO) rule audits the perimeter security of **Google API Keys** (`google_apikeys_key`).

Unlike IAM identities, API Keys are not authenticated by a user; they are validated by simple possession. Therefore, it is imperative to restrict their use to specific IP addresses, web domains, or mobile applications.

This rule ensures that the defense-in-depth principle is applied. Since a static analysis tool cannot determine whether a configured IP address or domain is legitimate or overly permissive, the rule alerts both on the absence of restrictions and on their presence, forcing a manual review of the allowlist.

## Rule Logic

The policy evaluates the resource in two stages:
1.  **Presence Validation:** If the `restrictions` block is missing, the key is flagged as vulnerable (public access).
2.  **Manual Validation:** If the `restrictions` block exists, an informational alert is generated so the auditor can confirm that the values (IPs, referrers, etc.) match the authorized corporate assets.

## Detected Failure Cases

The following scenarios will be detected by this policy.

---

### Case 1: No Restrictions (Vulnerable)
* **Description:** The API key lacks client restrictions, allowing anyone with the key to make calls from anywhere on the Internet.
* **Alert Location:** `google_apikeys_key` resource block.

### Case 2: Restrictions Review (Manual Check)
* **Description:** The key has restrictions configured. The auditor must verify that the defined values are not generic or incorrect.
* **Alert Location:** `restrictions` attribute.

## Resource Involved

* `google_apikeys_key`

## Solution

Always implement the `restrictions` block using the restriction type that best suits the key's use case (Browser, Server, Android, or iOS).

```terraform
resource "google_apikeys_key" "secure_api_key" {
  name = "frontend-maps-key"

  restrictions {
    # Example: Key restricted to a specific domain
    browser_key_restrictions {
      allowed_referrers = ["[https://app.example.com/](https://app.example.com/)*"]
    }

    # Recommended: Combine with API restriction (API Targets)
    api_targets {
      service = "maps-backend.googleapis.com"
    }
  }
}
