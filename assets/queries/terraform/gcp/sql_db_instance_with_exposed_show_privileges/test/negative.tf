resource "google_sql_database_instance" "negative_1" {
  name             = "main-instance"
  database_version = "POSTGRES_15"      # Is not a MYSQL instance
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database_instance" "negative_2" {
  name             = "mysql-instance-with-flag"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {
      name = "skip_show_database"         # Has flag set to "on"
      value = "on"
      }

    database_flags {
      name = "sample_flag2"
      value = "off"
      }
  }
}

resource "google_sql_database_instance" "negative_3" { # Single object support test
  name             = "mysql-instance-with-flag"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "skip_show_database"
      value = "on"
      }   # Has flag set to "on"
  }
}
