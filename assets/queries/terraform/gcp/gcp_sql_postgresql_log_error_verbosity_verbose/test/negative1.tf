resource "google_sql_database_instance" "pass" {
  name             = "postgres-ok"
  database_version = "POSTGRES_14"

  settings {
    database_flags {
      name  = "log_error_verbosity"
      value = "default"
    }
  }
}