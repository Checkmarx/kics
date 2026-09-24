resource "ibm_logdna_view" "audit_view" {
  name  = "Audit-Events"
  query = "service:iam"
}

resource "ibm_logdna_alert" "audit_alert" {
  name = "Audit-Alert-Policy"
  view = ibm_logdna_view.audit_view.name
  
  notification_channel {
    email {
      recipients = ["admin@example.com"]
    }
  }
}