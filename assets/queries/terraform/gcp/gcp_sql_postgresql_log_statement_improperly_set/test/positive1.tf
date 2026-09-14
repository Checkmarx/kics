resource "google_sql_database_instance" "fail_missing_flag" {
  name             = "postgres-no-audit"
  database_version = "POSTGRES_13"

  settings {
    tier = "db-f1-micro"
    database_flags {
      name  = "log_connections"
      value = "on"
    }
  }
}