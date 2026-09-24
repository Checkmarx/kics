resource "oci_identity_domains_password_policy" "missing_attr" {
  idcs_endpoint = "https://idcs-..."
  name          = "MissingAttrPolicy"
  
  # FAIL: Missing num_passwords_in_history
  password_min_length = 14
  schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:extension:passwordState:User"]
}