# KICS Rule: GCP Access Approval Disabled

## Overview

This **MEDIUM** severity rule audits compliance with third-party access control in **Google Cloud (GCP)** for `google_project` resources.

**Access Approval** is an advanced security control that allows organizations to establish an explicit approval step before Google personnel (Engineering or Support) can access customer data. While Google encrypts data by default and restricts access through internal policies, Access Approval grants the customer final sovereignty: any access attempt generates a request via email or Cloud Pub/Sub that the customer must manually approve.

Without this configuration, it is assumed that Google personnel can access resources for technical support purposes under the standard contract terms, which may not be sufficient for companies subject to strict regulations.

## Rule Logic

The policy performs two validations in Terraform code:
1.  **Configuration Existence:** Detects if a `google_project` lacks a `google_access_approval_project_settings` resource managing it.
2.  **Service Enrollment:** Verifies that, if the configuration exists, it includes at least one `enrolled_services` block. A configuration resource without enrolled services does not actively protect any GCP product.

## Detected Failure Cases

The following scenarios will be detected by this policy.

---

### Case 1: Project Without Access Approval
* **Description:** A project is provisioned in GCP but the Google access approval workflow is not implemented.
* **Alert Location:** `google_project` resource block.

### Case 2: Missing Service Configuration
* **Description:** The Access Approval configuration resource is defined but the protected services block is left empty.
* **Alert Location:** `google_access_approval_project_settings` resource.

## Resources Involved

* `google_project`
* `google_access_approval_project_settings`

## Solution

Define the configuration resource and ensure the desired services are enrolled (or `all` for full coverage).

```terraform
resource "google_access_approval_project_settings" "compliant_settings" {
  project_id = google_project.my_secure_project.project_id

  enrolled_services {
    cloud_product = "all" # Protects all compatible products
    enrollment_level = "BLOCK_ALL"
  }

  notification_emails = ["security-team@your-company.com"]
}
