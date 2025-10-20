resource "google_sql_database_instance" "positive_1" {
  name             = "mysql-instance-without-flag"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  # Missing 'settings' field
}

resource "google_sql_database_instance" "positive_2" {
  name             = "mysql-instance-without-flag"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  settings {}  # Missing 'database_flags' field
}

resource "google_sql_database_instance" "positive_3" {
  name             = "mysql-instance-without-flag"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  settings {
    database_flags = [
      # Missing 'skip_show_database' flag
    ]
  }
}

resource "google_sql_database_instance" "positive_4" {
  name             = "mysql-instance-with-flag"
  database_version = "MYSQL_8_0"
  region           = "us-central1"

  settings {
    database_flags = [
      { name = "skip_show_database1", value = "off" },  # Flag is not set to "on"
      { name = "skip_show_database2", value = "off" },  # Flag is not set to "on"
      { name = "skip_show_database3", value = "off" },  # Flag is not set to "on"
      { name = "skip_show_database", value = "off" },  # Flag is not set to "on"
      { name = "skip_show_database4", value = "off" },  # Flag is not set to "on"
      { name = "skip_show_database5", value = "off" }  # Flag is not set to "on"
    ]
  }
}
