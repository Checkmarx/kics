# Caso Pass: Valor DDL
resource "google_sql_database_instance" "pass_ddl" {
  name             = "postgres-ok-ddl"
  database_version = "POSTGRES_13"
  settings {
    database_flags {
      name  = "log_statement"
      value = "ddl"
    }
  }
}