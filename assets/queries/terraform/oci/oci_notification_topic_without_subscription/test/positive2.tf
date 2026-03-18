provider "oci" {
  region = "us-ashburn-1"
}

# Caso: Tópico existe pero no tiene suscripción que lo apunte
resource "oci_ons_notification_topic" "orphan_topic" {
  compartment_id = "ocid1.compartment..."
  name           = "orphan-topic"
}