resource "google_sql_database_instance" "positive_1" {
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {
      name = "log_min_error_statement"
      value = "NOTICE"
      } # Flag is set to "NOTICE"

    database_flags {
      name = "sample_flag2"
      value = "off"
      }
  }
}

resource "google_sql_database_instance" "positive_2" {   # Single object support test 1
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_13"
  region           = "us-central1"

  settings {
    database_flags {
      name = "log_min_error_statement"
      value = "DEBUG5"   # Flag is set to "DEBUG5"
    }
  }
}

resource "google_sql_database_instance" "positive_3" {    # Single object support test 2
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_13"
  region           = "us-central1"

  settings {
    database_flags {
     name = "log_min_error_statement"
     value = "DEBUG4"   # Flag is set to "DEBUG4"
    }
  }
}
