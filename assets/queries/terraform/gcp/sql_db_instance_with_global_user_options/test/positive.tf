resource "google_sql_database_instance" "positive_1" {
  name             = "sqlserver-instance-with-flag"
  database_version = "SQLSERVER_2017_EXPRESS"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {                          # Flag is not set to "0" - "32" triggers "ANSI_NULLS" option
      name = "user options"
      value = "32"
      }

    database_flags {
      name = "sample_flag2"
      value = "off"
      }
  }
}

resource "google_sql_database_instance" "positive_2" { # Single object support test
  name             = "sqlserver-instance-with-flag"
  database_version = "SQLSERVER_2017_EXPRESS"
  region           = "us-central1"

  settings {
    database_flags {
      name = "user options"
      value = "16"
      }  # Flag is not set to "0" - "16" triggers "ANSI_PADDING" option
  }
}
