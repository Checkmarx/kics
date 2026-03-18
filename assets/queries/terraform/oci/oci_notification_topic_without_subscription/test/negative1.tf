provider "oci" {
  region = "us-ashburn-1"
}

resource "oci_ons_notification_topic" "linked_topic" {
  compartment_id = "ocid1.compartment..."
  name           = "linked-topic"
}

# Esta suscripción apunta correctamente al tópico de arriba
resource "oci_ons_subscription" "sub_for_linked" {
  compartment_id = "ocid1.compartment..."
  topic_id       = oci_ons_notification_topic.linked_topic.id
  protocol       = "EMAIL"
  endpoint       = "test@example.com"
}