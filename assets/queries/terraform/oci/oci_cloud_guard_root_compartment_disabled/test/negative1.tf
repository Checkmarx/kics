provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_cloud_guard_configuration" "cg_correct" {
  # CORRECTO: Contiene la palabra "tenancy"
  compartment_id   = var.tenancy_ocid
  reporting_region = "us-ashburn-1"
  status           = "ENABLED"
}