resource "google_sql_database_instance" "master1" {
    name             = "master-instance"
    database_version = "POSTGRES_11"
    region           = "us-central1"

    settings {

    }
}

resource "google_sql_database_instance" "master2" {
    name             = "master-instance"
    database_version = "POSTGRES_11"
    region           = "us-central1"

    settings {
        backup_configuration{

        }
    }
}

resource "google_sql_database_instance" "master3" {
    name             = "master-instance"
    database_version = "POSTGRES_11"
    region           = "us-central1"

    settings {
        backup_configuration{
            enabled = false
        }
    }
}

