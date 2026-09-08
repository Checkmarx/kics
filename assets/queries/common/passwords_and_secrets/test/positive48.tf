# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08                           positive-test   - #1
# Global allow rule  - a88baa34-e2ad-44ea-ad6f-8cac87bc7c71 - "Avoiding TF variables" allow-rule-test - #2
resource "google_container_cluster" "primary1" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = "varexample" #1

    client_certificate_config {
      issue_client_certificate = true
      password = var.example  #2
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
