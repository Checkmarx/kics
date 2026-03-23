# KICS Rule: Microsoft Defender EASM Enabled (Manual)

## General Description

This rule acts as a **manual compliance reminder**. Its objective is to ensure that **Microsoft Defender External Attack Surface Monitoring (EASM)** has been enabled to monitor the exposure of Azure assets to the Internet.

EASM continuously discovers your digital assets (IP addresses, domains, SSL certificates, etc.) to identify vulnerabilities and risks in the "shadow" (Shadow IT). Since the current Terraform provider for Azure does not have native resources to manage this service, verification must be performed directly on the platform.

## Rule Logic

Due to the limitations of static analysis for this specific service:
1.  The rule identifies the presence of `azurerm_resource_group` resources.
2.  It generates an **INFO** severity alert for each detected group.
3.  It acts as a checklist for the security team to validate the service status in the Azure Portal.

## Detected Failure Cases

### Case 1: Manual Verification Required

* **Description:** Deployed infrastructure has been detected, but the EASM protection status is not visible to KICS.
* **Alert Location:** On the `azurerm_resource_group` resource.

## Involved Resource

* `azurerm_resource_group`

## Solution

This alert is not resolved through changes in standard HCL code.

**Manual remediation steps:**
1.  Access the [Azure Portal](https://portal.azure.com).
2.  In the top search bar, type **"Microsoft Defender EASM"**.
3.  Verify whether an EASM resource is configured and performing active scans.
4.  If it does not exist, consider creating it to improve the external security posture.
5.  Document the verification to close the finding in the KICS report.
