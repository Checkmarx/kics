provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_policy" "read_only_storage" {
  name           = "ReadOnlyStorage"
  compartment_id = "ocid1.tenancy..."

  # CORRECTO: El verbo es read, no incluye delete
  statements = [
    "Allow group Auditors to read object-family in tenancy"
  ]
}