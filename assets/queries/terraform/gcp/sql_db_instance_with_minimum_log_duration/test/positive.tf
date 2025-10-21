resource "google_sql_database_instance" "positive" {
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags = [
      { name = "sample_flag1", value = "off" },
      { name = "log_min_duration_statement", value = "2" },  # Flag is not set to "-1"
      { name = "sample_flag2", value = "off" }
    ]
  }
}
