resource "google_sql_database_instance" "fail_multiple" {
  name             = "postgres-multiple-flags"
  database_version = "POSTGRES_14"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name  = "log_connections"
      value = "on"
    }

    database_flags {
      name  = "log_error_verbosity"
      value = "verbose"
    }
  }
}