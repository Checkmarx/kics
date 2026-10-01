# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08 - "Avoiding TF resource access"  allow-rule-test
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = local.rds_postgres_is_primary ? var.rds_postgres_password : null # negative1

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
