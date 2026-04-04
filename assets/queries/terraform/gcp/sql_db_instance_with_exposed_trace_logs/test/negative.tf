resource "google_sql_database_instance" "negative_1" {
  name             = "main-instance"
  database_version = "MYSQL_8_0"      # Is not a SQLSERVER instance
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database_instance" "negative_2" {
  name             = "mysql-instance-with-flag"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {                                  # Has flag set to "on"
      name = "3625"
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
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "3625"
      value = "on"
      }   # Has flag set to "on"
  }
}

resource "google_sql_database_instance" "negative_4" {
  name             = "main-instance"
  database_version = "SQLSERVER_2019_STANDARD"
  region           = "us-central1"

  # Missing "settings" but "clone" is set

  clone {
    source_instance_name = google_sql_database_instance.source.name
  }
}
