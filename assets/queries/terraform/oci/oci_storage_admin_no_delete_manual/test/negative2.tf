provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_policy" "false_positive_check" {
  name           = "ManagerCheck"
  compartment_id = "ocid1.tenancy..."

  # CORRECTO: Aunque el grupo se llama Managers, el verbo es read. El regex \bmanage\b evita el fallo.
  statements = [
    "Allow group ObjectManagers to read object-family in tenancy"
  ]
}