provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_policy" "unsafe_object_admin" {
  name           = "UnsafeObjectAdmin"
  compartment_id = "ocid1.tenancy..."
  
  # FALLO: Otorga manage (incluye delete) en object-family
  statements = [
    "Allow group StorageAdmins to manage object-family in tenancy"
  ]
}