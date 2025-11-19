resource "google_sql_database_instance" "negative_1" {
  name             = "main-instance"
  database_version = "MYSQL_8_0"      # Is not a POSTGRES instance
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "log_min_error_statement"
      value = "DEBUG3"
    }
  }
}

resource "google_sql_database_instance" "negative_2" {
  name             = "mysql-instance-without-flag"
  database_version = "POSTGRES_17"
  region           = "us-central1"

  # Defaults to "ERROR"
}

resource "google_sql_database_instance" "negative_3" {
  name             = "postgres-instance-without-flag"
  database_version = "POSTGRES_16"
  region           = "us-central1"

  settings {}  # Defaults to "ERROR"
}

resource "google_sql_database_instance" "negative_4" {
  name             = "postgres-instance-without-flag"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    database_flags {
      name = "sample_flag1"
      value = "off"
    }
      # Defaults to "ERROR"
  }
}

resource "google_sql_database_instance" "negative_5" {
  name             = "mysql-instance-with-flag"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "sample_flag1"
      value = "off"
    }

    database_flags {
      name = "log_min_error_statement"
      value = "ERROR"
    } # Has flag set to "ERROR" (minimum)

    database_flags {
      name = "sample_flag2"
      value = "off"
    }
  }
}

resource "google_sql_database_instance" "negative_6" { # Single object support test 1
  name             = "mysql-instance-with-flag"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "log_min_error_statement"
      value = "LOG"
      } # Has flag set to "LOG"
  }
}

resource "google_sql_database_instance" "negative_7" { # Single object support test 1
  name             = "mysql-instance-with-flag"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "log_min_error_statement"
      value = "FATAL"
      } # Has flag set to "FATAL"
  }
}

resource "google_sql_database_instance" "negative_8" { # Single object support test 1
  name             = "mysql-instance-with-flag"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"

    database_flags {
      name = "log_min_error_statement"
      value = "PANIC"
      } # Has flag set to "PANIC"
  }
}
