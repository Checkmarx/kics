resource "google_sql_database_instance" "fail" {
  name             = "my-postgres"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }
  }
}
