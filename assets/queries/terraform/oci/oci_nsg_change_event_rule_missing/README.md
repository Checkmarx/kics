# Regla KICS: Notificación para Cambios en Grupos de Seguridad de Red (NSG) en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para monitorizar y generar alertas ante cualquier cambio (creación, actualización o eliminación) en los Grupos de Seguridad de Red (NSG) de la cuenta de OCI.

Los NSG proporcionan un firewall virtual para un conjunto de recursos. Un cambio no autorizado en un NSG podría exponer una aplicación a internet o permitir movimientos laterales no deseados.

## Lógica de la Regla

La política verifica que exista configuración activa para capturar los tres tipos de eventos críticos de NSG:
1. `com.oraclecloud.virtualnetwork.createnetworksecuritygroup`
2. `com.oraclecloud.virtualnetwork.updatenetworksecuritygroup`
3. `com.oraclecloud.virtualnetwork.deletenetworksecuritygroup`

## Casos de Fallo Detectados

### Caso 1: Regla Ausente (Missing)
* **Descripción:** No existe ninguna regla configurada para NSGs en el proyecto.
* **Ubicación de la Alerta:** Bloque `provider "oci"`.

### Caso 2: Regla Incompleta (Incomplete)
* **Descripción:** Existe una regla para NSGs, pero le faltan eventos (ej. monitoriza create pero olvida delete).
* **Ubicación de la Alerta:** Atributo `condition`.

### Caso 3: Regla Deshabilitada (Disabled)
* **Descripción:** Existe una regla relevante pero está explícitamente deshabilitada (`is_enabled = false`).
* **Ubicación de la Alerta:** Atributo `is_enabled` dentro del recurso.

## Solución

```terraform
resource "oci_events_rule" "nsg_change_rule" {
  display_name   = "audit-rule-for-nsg-changes"
  description    = "Alerts on any creation, update, or deletion of Network Security Groups"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  condition = jsonencode({
    eventType = [
      "com.oraclecloud.virtualnetwork.createnetworksecuritygroup",
      "com.oraclecloud.virtualnetwork.updatenetworksecuritygroup",
      "com.oraclecloud.virtualnetwork.deletenetworksecuritygroup"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}