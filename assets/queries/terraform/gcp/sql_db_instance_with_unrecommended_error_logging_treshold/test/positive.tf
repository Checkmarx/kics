resource "google_sql_database_instance" "positive_1" {
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags = [
      { name = "sample_flag1", value = "off" },
      { name = "log_min_error_statement", value = "NOTICE" },  # Flag is set to "NOTICE"
      { name = "sample_flag2", value = "off" }
    ]
  }
}

resource "google_sql_database_instance" "positive_2" {
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_13"
  region           = "us-central1"

  settings {
    database_flags = [
      { name = "log_min_error_statement", value = "DEBUG5" },  # Flag is set to "DEBUG5"
    ]
  }
}
