resource "oci_identity_domains_password_policy" "secure_policy" {
  idcs_endpoint = "https://idcs-..."
  name          = "SecurePolicy"
  
  # CORRECTO: >= 24
  num_passwords_in_history = 24
  
  schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:extension:passwordState:User"]
}