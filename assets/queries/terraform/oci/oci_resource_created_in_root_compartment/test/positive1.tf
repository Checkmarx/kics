provider "oci" {
  region = "us-ashburn-1"
}

variable "tenancy_ocid" {}

# Caso: Uso explícito de var.tenancy_ocid
resource "oci_core_vcn" "root_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.tenancy_ocid
  display_name   = "RootVCN"
}