# KICS Rule: Cloud SQL PostgreSQL log_statement Improperly Set

## Overview

This rule verifies the configuration of the `log_statement` flag in **Google Cloud SQL (PostgreSQL)** instances.

This parameter controls which SQL statements are logged in the server logs:
* **`none`:** Does not log any statements (Default).
* **`ddl`:** Logs data definition statements (CREATE, ALTER, DROP). Recommended by CIS Benchmark as a baseline.
* **`mod`:** Logs DDL and data modification statements (INSERT, UPDATE, DELETE).
* **`all`:** Logs all statements.

To comply with audit and security regulations, it must be configured to at least `ddl` to track structural changes in the database that could compromise its integrity.

## Rule Logic

The policy evaluates the `google_sql_database_instance` resource (PostgreSQL):
1.  **Missing Flag:** If `log_statement` is not found within the list of configured flags, it fails (since PostgreSQL's default value is insufficient for auditing).
2.  **Incorrect Flag:** If `log_statement` is present but its value is explicitly `none`, it fails.

## Detected Failure Cases

### Case 1: Missing Configuration
* **Description:** The flag has not been defined, so the database is not auditing critical statements.
* **Alert Location:** `database_flags` block.

### Case 2: Auditing Explicitly Disabled
* **Description:** The flag is configured with the value `none`, disabling statement logging.
* **Alert Location:** `database_flags` block.

## Resource Involved

* `google_sql_database_instance`

## Solution

Set the value of the `log_statement` flag to `ddl` (minimum recommended for auditing), `mod`, or `all`.

```terraform
resource "google_sql_database_instance" "secure" {
  name             = "secure-postgresql"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags {
      name  = "log_statement"
      value = "ddl"
    }
  }
}
