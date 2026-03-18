resource "oci_identity_domains_password_policy" "correct_policy" {
  idcs_endpoint = "https://idcs-..."
  name          = "CorrectPolicy"
  # CORRECTO: <= 365
  password_expires_after = 90
  schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:extension:passwordState:User"]
}