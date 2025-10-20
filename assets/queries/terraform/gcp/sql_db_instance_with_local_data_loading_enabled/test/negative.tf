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

    database_flags = [
      { name = "local_infile", value = "off" },   # Has flag set to "off"
    ]
  }
}
