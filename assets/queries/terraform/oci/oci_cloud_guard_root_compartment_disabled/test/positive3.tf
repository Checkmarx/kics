provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_cloud_guard_configuration" "cg_child" {
  # FALLO: Apunta a un compartimento hijo, no al tenancy
  compartment_id   = var.child_compartment_id
  reporting_region = "us-ashburn-1"
  status           = "ENABLED"
}