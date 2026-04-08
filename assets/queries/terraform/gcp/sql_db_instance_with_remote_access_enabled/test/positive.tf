resource "google_sql_database_instance" "positive_1" {
  name             = "mysql-instance-without-flag"
  database_version = "SQLSERVER_2017_STANDARD"
  region           = "us-central1"

  # Missing 'settings' field
}

resource "google_sql_database_instance" "positive_2" {
  name             = "sqlserver-instance-without-flag"
  database_version = "SQLSERVER_2017_STANDARD"
  region           = "us-central1"

  settings {}  # Missing 'database_flags' field
}

resource "google_sql_database_instance" "positive_3" {
  name             = "sqlserver-instance-without-flag"
  database_version = "SQLSERVER_2017_STANDARD"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
      } # Missing 'remote access' flag
  }
}

resource "google_sql_database_instance" "positive_4" {
  name             = "sqlserver-instance-with-flag"
  database_version = "SQLSERVER_2017_EXPRESS"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {                                  # Flag is not set to "off"
      name = "remote access"
      value = "on"
      }

    database_flags {
      name = "sample_flag2"
      value = "off"
      }
  }
}

resource "google_sql_database_instance" "positive_5" { # Single object support test
  name             = "sqlserver-instance-with-flag"
  database_version = "SQLSERVER_2017_EXPRESS"
  region           = "us-central1"

  settings {
    database_flags {
      name = "remote access"
      value = "on"
      }  # Flag is not set to "off"
  }

  clone {
    source_instance_name = google_sql_database_instance.source_instance.id
  }
}
