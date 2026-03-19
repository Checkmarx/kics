resource "oci_identity_authentication_policy" "secure_policy" {
  compartment_id = "ocid1.tenancy..."
  
  password_policy {
    # CORRECTO: >= 14
    minimum_password_length = 14
    is_lowercase_characters_required = true
  }
}