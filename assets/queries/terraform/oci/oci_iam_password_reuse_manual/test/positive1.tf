resource "oci_identity_domains_password_policy" "weak_history" {
  idcs_endpoint = "https://idcs-..."
  name          = "WeakHistoryPolicy"
  
  # FALLO: 5 es menor que 24
  num_passwords_in_history = 5
  
  schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:extension:passwordState:User"]
}