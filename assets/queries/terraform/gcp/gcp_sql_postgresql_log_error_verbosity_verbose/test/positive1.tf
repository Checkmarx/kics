resource "google_sql_database_instance" "fail_single" {
  name             = "postgres-single-flag"
  database_version = "POSTGRES_14"

  settings {
    tier = "db-f1-micro"
    database_flags {
      name  = "log_error_verbosity"
      value = "verbose"
    }
  }
}