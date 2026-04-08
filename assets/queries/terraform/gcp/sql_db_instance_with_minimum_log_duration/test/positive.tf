resource "google_sql_database_instance" "positive_1" {
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {                                  # Flag is not set to "-1"
      name = "log_min_duration_statement"
      value = "2"
      }

    database_flags {
      name = "sample_flag2"
      value = "off"
      }
  }
}

resource "google_sql_database_instance" "positive_2" { # Single object support test
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags {
       name = "log_min_duration_statement"
       value = "3"
       }  # Flag is not set to "-1"
  }
}
