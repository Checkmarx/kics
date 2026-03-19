# Regla KICS: Tópicos de Notificación con Suscripción en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que los tópicos de notificación del servicio OCI Notifications (`oci_ons_notification_topic`) tengan al menos una suscripción (`oci_ons_subscription`) asociada.

El servicio de notificaciones de OCI se usa para desacoplar componentes y enviar alertas. Un "tópico" es el canal al que se publican los mensajes, pero sin una "suscripción" (email, función, webhook, etc.), esos mensajes no se entregan a ningún destino y se pierden.

## Lógica de la Regla

La política se divide en dos reglas para cubrir los posibles escenarios de fallo:
1.  **Ausencia Global:** No hay tópicos de notificación definidos.
2.  **Tópico Huérfano:** Existe un tópico que no está referenciado por ninguna suscripción.

## Casos de Fallo Detectados

### Caso 1: Recurso `oci_ons_notification_topic` Ausente
* **Descripción:** No se encuentra ni un solo recurso de tipo `oci_ons_notification_topic` en el proyecto.
* **Ubicación de la Alerta:** Bloque `provider "oci"`.

### Caso 2: Tópico sin Suscripciones Asociadas
* **Descripción:** Existe un recurso `oci_ons_notification_topic`, pero no existe ningún `oci_ons_subscription` cuyo `topic_id` apunte a él.
* **Ubicación de la Alerta:** Recurso `oci_ons_notification_topic`.

## Solución

Asegúrate de que exista al menos un tópico y que tenga una suscripción enlazada:

```terraform
resource "oci_ons_notification_topic" "critical_alerts" {
  compartment_id = var.compartment_id
  name           = "my-critical-alerts-topic"
}

# RECURSO REQUERIDO: La suscripción que enlaza al tópico
resource "oci_ons_subscription" "email_subscription" {
  compartment_id = var.compartment_id
  
  # Referencia cruzada al tópico
  topic_id = oci_ons_notification_topic.critical_alerts.id
  
  protocol = "EMAIL"
  endpoint = "ops-team@example.com"
}