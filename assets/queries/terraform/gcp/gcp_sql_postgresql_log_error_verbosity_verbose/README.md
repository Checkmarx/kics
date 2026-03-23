# KICS Rule: Cloud SQL PostgreSQL log_error_verbosity is Verbose

## Overview

This rule verifies the configuration of the `log_error_verbosity` database flag in **Google Cloud SQL (PostgreSQL)** instances.

This parameter controls the amount of detail written to the server error log. The `verbose` level includes internal information such as source code and line numbers, which is not recommended for production environments for security and performance reasons.

## Rule Logic

The policy inspects the `google_sql_database_instance` resource:
1.  Verifies if the database version contains "POSTGRES".
2.  Normalizes the `settings.database_flags` block to correctly process configurations with both single and multiple flags.
3.  If it finds a flag named `log_error_verbosity` with the value `verbose`, it generates an alert.

## Detected Failure Cases

### Case 1: Insecure Verbosity

* **Description:** The flag is explicitly configured as `verbose`.
* **Alert Location:** `database_flags` block.

## Resource Involved

* `google_sql_database_instance`

## Solution

Set the value to `default`, `terse`, or remove the flag.

```terraform
resource "google_sql_database_instance" "secure" {
  database_version = "POSTGRES_14"
  settings {
    database_flags {
      name  = "log_error_verbosity"
      value = "default"
    }
  }
}
