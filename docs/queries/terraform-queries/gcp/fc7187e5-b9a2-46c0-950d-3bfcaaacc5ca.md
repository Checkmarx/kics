---
title: Beta - SQL DB Instance Without Connections Logging
hide:
  toc: true
  navigation: true
---

<style>
  .highlight .hll {
    background-color: #ff171742;
  }
  .md-content {
    max-width: 1100px;
    margin: 0 auto;
  }
</style>

-   **Query id:** fc7187e5-b9a2-46c0-950d-3bfcaaacc5ca
-   **Query name:** Beta - SQL DB Instance Without Connections Logging
-   **Platform:** Terraform
-   **Severity:** <span style="color:#ff7213">Medium</span>
-   **Category:** Observability
-   **CWE:** <a href="https://cwe.mitre.org/data/definitions/778.html" onclick="newWindowOpenerSafe(event, 'https://cwe.mitre.org/data/definitions/778.html')">778</a>
-   **Risk score:** <span style="color:#ff7213">3.0</span>
-   **URL:** [Github](https://github.com/Checkmarx/kics/tree/master/assets/queries/terraform/gcp/sql_db_instance_without_connections_logging)

### Description
All 'google_sql_database_instance' resources based on POSTGRES should enable the 'log_connections' flag to log connection attempts<br>
[Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance.html#settings-1)

### Code samples
#### Code samples with security vulnerabilities
```tf title="Positive test num. 1 - tf file" hl_lines="1 42 14 23 60"
resource "google_sql_database_instance" "positive_1" {
  name             = "mysql-instance-without-flag"
  database_version = "POSTGRES_17"
  region           = "us-central1"

  # Missing 'settings' field
}

resource "google_sql_database_instance" "positive_2" {
  name             = "postgres-instance-without-flag"
  database_version = "POSTGRES_16"
  region           = "us-central1"

  settings {}  # Missing 'database_flags' field
}

resource "google_sql_database_instance" "positive_3" {
  name             = "postgres-instance-without-flag"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
      } # Missing 'log_connections' flag
  }
}

resource "google_sql_database_instance" "positive_4" {
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {
      name = "log_connections"    # Flag is not set to "on"
      value = "off"
      }

    database_flags {
      name = "sample_flag2"
      value = "off"
      }
  }
}

resource "google_sql_database_instance" "positive_5" {   # Single object support test
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags {
      name = "log_connections"
      value = "off"
      }  # Flag is not set to "on"
  }
}

```


#### Code samples without security vulnerabilities
```tf title="Negative test num. 1 - tf file"
resource "google_sql_database_instance" "negative_1" {
  name             = "main-instance"
  database_version = "MYSQL_8_0"      # Is not a POSTGRES instance
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database_instance" "negative_2" {
  name             = "mysql-instance-with-flag"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {
      name = "log_connections"    # Has flag set to "on"
      value = "on"
      }

    database_flags {
      name = "sample_flag2"
      value = "off"
      }
  }
}

resource "google_sql_database_instance" "negative_3" {  # Single object support test
  name             = "mysql-instance-with-flag"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "log_connections"
      value = "on"
      }   # Has flag set to "on"
  }
}

```

