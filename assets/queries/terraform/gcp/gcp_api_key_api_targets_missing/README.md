# KICS Rule: Google API Key API Targets Missing

## Overview

This **MEDIUM** severity rule audits the configuration of **Google API Keys** (`google_apikeys_key`) to ensure access is limited exclusively to the necessary services.

When an API Key is generated in Google Cloud, it is capable by default of invoking **any enabled API** in the project. This represents a significant security and cost risk; if a key is compromised (for example, by being accidentally exposed in a mobile or web application's source code), an attacker could use it to consume sensitive or high-cost services (such as the Google Maps API or AI models) that are not part of the application's original purpose.

The security best practice is to apply "API Targets" restrictions so that the key only works with the specific services for which it was created.

## Rule Logic

The policy evaluates two failure scenarios in Terraform code:
1.  **Absence of Restrictions:** The resource does not define any `restrictions` block, leaving the key completely unprotected.
2.  **Missing API Scope:** The resource defines restrictions (such as IPs or referrers), but omits the `api_targets` block, allowing those authorized origins to consume any API in the project.

## Detected Failure Cases

The following scenarios will be detected by this policy.

---

### Case 1: Missing Restrictions
* **Description:** The API key is defined without any perimeter or service controls.
* **Alert Location:** `google_apikeys_key` resource block.

### Case 2: API Targets Not Defined
* **Description:** Client restrictions are applied, but unlimited access to all Google services enabled in the project is maintained.
* **Alert Location:** `restrictions` attribute.

## Resource Involved

* `google_apikeys_key`

## Solution

Add the `api_targets` block inside the `restrictions` section specifying the required services.

```terraform
resource "google_apikeys_key" "secure_key" {
  name = "production-maps-key"

  restrictions {
    # Origin restriction (example for browser)
    browser_key_restrictions {
      allowed_referrers = ["[https://app.your-company.com/](https://app.your-company.com/)*"]
    }

    # Service restriction (Solution)
    api_targets {
      service = "maps-backend.googleapis.com"
    }
    api_targets {
      service = "places-backend.googleapis.com"
    }
  }
}
