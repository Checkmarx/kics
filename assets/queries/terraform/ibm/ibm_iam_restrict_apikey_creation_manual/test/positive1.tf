resource "ibm_iam_user_policy" "high_privilege_user" {
  ibm_id = "user@example.com"
  roles  = ["Administrator"] # Alerta: requiere revisión manual
  
  resources {
    service = "iam-identity"
  }
}