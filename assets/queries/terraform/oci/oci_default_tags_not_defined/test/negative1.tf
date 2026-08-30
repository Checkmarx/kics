provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_identity_tag_namespace" "example_ns" {
  compartment_id = "ocid1.compartment..."
  description    = "Namespace"
  name           = "example-namespace"
}

resource "oci_identity_tag" "example_tag" {
  tag_namespace_id = oci_identity_tag_namespace.example_ns.id
  description      = "Tag"
  name             = "CostCenter"
}

resource "oci_identity_tag_default" "example_default_tag" {
  compartment_id    = "ocid1.compartment..."
  tag_definition_id = oci_identity_tag.example_tag.id
  value             = "IT-DEPT-123"
  is_required       = true
}