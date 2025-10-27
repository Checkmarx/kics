resource "google_sql_database_instance" "negative_1" {
  name             = "main-instance"
  database_version = "MYSQL_8_0"      # Is not a SQLSERVER instance
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "contained database authentication"
      value = "on"
      }
  }
}

resource "google_sql_database_instance" "negative_2" {
  name             = "sqlserver-instance-without-flag"
  database_version = "SQLSERVER_2017_STANDARD"
  region           = "us-central1"

  # Defaults to "off"
}

resource "google_sql_database_instance" "negative_3" {
  name             = "sqlserver-instance-without-flag"
  database_version = "SQLSERVER_2017_STANDARD"
  region           = "us-central1"

  settings {}  # Defaults to "off"
}

resource "google_sql_database_instance" "negative_4" {
  name             = "sqlserver-instance-without-flag"
  database_version = "SQLSERVER_2017_STANDARD"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag"
      value = "off"
      }
      # Defaults to "off"
  }
}

resource "google_sql_database_instance" "negative_5" {
  name             = "sqlserver-instance-with-flag"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {                                  # Has flag set to "off" - array
      name = "contained database authentication"
      value = "off"
      }

    database_flags {
      name = "sample_flag2"
      value = "off"
      }
  }
}

resource "google_sql_database_instance" "negative_6" { # Single object support test
  name             = "sqlserver-instance-with-flag"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "contained database authentication"
      value = "off"
      }
  }
}
