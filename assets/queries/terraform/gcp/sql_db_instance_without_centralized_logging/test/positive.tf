resource "google_sql_database_instance" "positive_1" {
  name             = "mysql-instance-without-flag"
  database_version = "POSTGRES_17"
  region           = "us-central1"

  # Missing 'settings' field
}

resource "google_sql_database_instance" "positive_2" {
  name             = "postgres-instance-without-flag"
  database_version = "POSTGRES_16"
  region           = "us-central1"

  settings {}  # Missing 'database_flags' field
}

resource "google_sql_database_instance" "positive_3" {
  name             = "postgres-instance-without-flag"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
      } # Missing 'cloudsql.enable_pgaudit' flag
  }
}

resource "google_sql_database_instance" "positive_4" {
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
      }

    database_flags {                                  # Flag is not set to "on"
      name = "cloudsql.enable_pgaudit"
      value = "off"
      }

    database_flags {
      name = "sample_flag2"
      value = "off"
      }
  }
}

resource "google_sql_database_instance" "positive_5" { # Single object support test
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags {
      name = "cloudsql.enable_pgaudit"
      value = "off"
      }  # Flag is not set to "on"
  }

  clone {
    source_instance_name = google_sql_database_instance.source_instance.id
  }
}
