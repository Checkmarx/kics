resource "google_sql_database_instance" "negative_1" {
  name             = "main-instance"
  database_version = "MYSQL_8_0"      # Is not a SQLSERVER instance
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags = [
      { name = "external scripts enabled", value = "on" },
    ]
  }
}

resource "google_sql_database_instance" "negative_2" {
  name             = "mysql-instance-without-flag"
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
    database_flags = [
      # Defaults to "off"
    ]
  }
}

resource "google_sql_database_instance" "negative_5" {
  name             = "mysql-instance-with-flag"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags = [
      { name = "external scripts enabled", value = "off" },   # Has flag set to "off"
    ]
  }
}

resource "google_sql_database_instance" "negative_6" { # Single object support test
  name             = "mysql-instance-with-flag"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "external scripts enabled"
      value = "off"
      }   # Has flag set to "off"
  }
}
