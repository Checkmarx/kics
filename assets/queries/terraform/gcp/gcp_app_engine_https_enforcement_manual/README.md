# KICS Rule: App Engine HTTPS Enforcement (Manual)

## Overview

This audit rule verifies that applications deployed on **Google App Engine** (Standard Environment) enforce the exclusive use of encrypted connections via **HTTPS**.

Serving content over unencrypted HTTP exposes users' confidential data and session credentials to interception. To mitigate this risk, App Engine allows configuring an automatic HTTP to HTTPS redirect.

Since App Engine typically uses an external configuration file (`app.yaml`) to define network behavior, this rule acts as a governance control that alerts if the policy is not explicitly defined in the infrastructure as code (Terraform) or if it requires manual inspection of deployment artifacts.

## Rule Logic

The policy evaluates the `google_app_engine_standard_app_version` resource under two scenarios:
1.  **Terraform Configuration:** If the `handlers` block is present, it ensures that the `security_level` attribute is configured as `SECURE_ALWAYS`. Any other value (such as `SECURE_OPTIONAL`) will trigger an alert.
2.  **External Configuration:** If no `handlers` are defined in Terraform, the rule generates an informational alert (**INFO**) indicating that compliance depends on the configuration within the application's `app.yaml` file.

## Detected Failure Cases

The following scenarios will be detected by this policy.

---

### Case 1: Insecure Security Level in Terraform
* **Description:** URL handlers allow HTTP traffic or do not enforce secure redirection.
* **Alert Location:** `handlers` attribute within the App Engine resource.

### Case 2: Manual Verification of Configuration Files
* **Description:** Terraform does not manage routing logic. The source code must be validated.
* **Required Action:** Confirm that in `app.yaml` all critical handlers contain:
    ```yaml
    secure: always
    ```
* **Alert Location:** `google_app_engine_standard_app_version` resource level.

## Resource Involved

* `google_app_engine_standard_app_version`

## Solution

To enforce HTTPS from Terraform, configure `security_level` in each handler:

```terraform
resource "google_app_engine_standard_app_version" "secure_app" {
  service    = "api-service"
  version_id = "v2"
  runtime    = "nodejs18"

  handlers {
    url_regex = "/.*"
    script {
      script_path = "auto"
    }
    # Technical solution
    security_level = "SECURE_ALWAYS"
  }
}
