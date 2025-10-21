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
    database_flags = [
      # Missing 'log_min_error_statement' flag
    ]
  }
}

resource "google_sql_database_instance" "positive_4" {
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags = [
      { name = "sample_flag1", value = "off" },
      { name = "log_min_error_statement", value = "NOTICE" },  # Flag is set to "NOTICE"
      { name = "sample_flag2", value = "off" }
    ]
  }
}

resource "google_sql_database_instance" "positive_5" {
  name             = "postgres-instance-with-flag"
  database_version = "POSTGRES_13"
  region           = "us-central1"

  settings {
    database_flags = [
      { name = "log_min_error_statement", value = "DEBUG5" },  # Flag is set to "DEBUG5"
    ]
  }
}
