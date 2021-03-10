resource "google_sql_database_instance" "negative1" {
    name             = "master-instance"
    database_version = "POSTGRES_11"
    region           = "us-central1"
 
    settings {
        backup_configuration{
            enabled = true
        }
    }
}
