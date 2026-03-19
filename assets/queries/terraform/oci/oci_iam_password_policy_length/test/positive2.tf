resource "oci_identity_authentication_policy" "missing_attr" {
  compartment_id = "ocid1.tenancy..."
  
  password_policy {
    # FALLO: Falta minimum_password_length
    is_lowercase_characters_required = true
  }
}