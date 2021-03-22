resource "google_project_iam_audit_config" "positive1" {
  project = "your-project-id"
  service = "some_specific_service"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
    exempted_members = [
      "user:joebloggs@hashicorp.com"
    ]
  }
}

resource "google_project_iam_audit_config" "positive2" {
  project = "your-project-id"
  service = "allServices"
  audit_log_config {
    log_type = "INVALID_TYPE"
  }
  audit_log_config {
    log_type = "DATA_READ"
    exempted_members = [
        "user:joebloggs@hashicorp.com"
    ]
  }
}