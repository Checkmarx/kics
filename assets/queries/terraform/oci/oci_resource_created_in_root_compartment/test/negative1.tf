provider "oci" {
  region = "us-ashburn-1"
}

variable "network_cmp_id" {}

resource "oci_core_vcn" "child_vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.network_cmp_id
  display_name   = "ChildVCN"
}

resource "oci_objectstorage_bucket" "child_bucket" {
  namespace      = "ns"
  name           = "child-bucket"
  compartment_id = "ocid1.compartment.oc1..bbbb..."
}