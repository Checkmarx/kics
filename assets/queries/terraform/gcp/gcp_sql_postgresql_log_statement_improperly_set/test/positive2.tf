resource "google_sql_database_instance" "fail_explicit_none" {
  name             = "postgres-none-audit"
  database_version = "POSTGRES_14"

  settings {
    database_flags {
      name  = "log_statement"
      value = "none" # FALLO
    }
  }
}