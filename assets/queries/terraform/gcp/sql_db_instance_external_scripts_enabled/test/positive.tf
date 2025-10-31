resource "google_sql_database_instance" "positive_1" {
  name             = "sqlserver-instance-with-flag"
  database_version = "SQLSERVER_2017_EXPRESS"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {                                  # Flag is not set to "off"
      name = "external scripts enabled"
      value = "on"
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
      name = "external scripts enabled"
      value = "on"
      }  # Flag is not set to "off"
  }
}
