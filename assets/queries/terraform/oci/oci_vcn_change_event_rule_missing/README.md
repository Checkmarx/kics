# Regla KICS: Notificación para Cambios en VCN en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para monitorizar y generar alertas ante cualquier cambio (creación, actualización o eliminación) en las Redes Virtuales en la Nube (VCN) de la cuenta de OCI.

Las VCN son el componente fundamental de la red en OCI. Cambios no autorizados pueden tener un impacto severo en la conectividad y la seguridad de los servicios.

## Lógica de la Regla

La política verifica la configuración de los recursos `oci_events_rule` buscando los tres tipos de eventos fundamentales:
* `com.oraclecloud.virtualnetwork.createvcn`
* `com.oraclecloud.virtualnetwork.updatevcn`
* `com.oraclecloud.virtualnetwork.deletevcn`

## Casos de Fallo Detectados

### Caso 1: Regla Ausente (Missing)
* **Descripción:** No existe ninguna regla en la configuración que monitorice cambios en VCNs.
* **Ubicación:** Bloque `provider "oci"`.

### Caso 2: Regla Incompleta (Incomplete)
* **Descripción:** Existe una regla pero no incluye los tres eventos requeridos (create, update, delete).
* **Ubicación:** Atributo `condition`.

### Caso 3: Regla Deshabilitada (Disabled)
* **Descripción:** Existe una regla relevante pero el atributo `is_enabled` es `false`.
* **Ubicación:** Atributo `is_enabled`.

## Solución

Asegúrate de incluir una regla habilitada con los eventos correspondientes:

```terraform
resource "oci_events_rule" "vcn_change_rule" {
  display_name   = "audit-rule-for-vcn-changes"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  condition = jsonencode({
    eventType = [
      "com.oraclecloud.virtualnetwork.createvcn",
      "com.oraclecloud.virtualnetwork.updatevcn",
      "com.oraclecloud.virtualnetwork.deletevcn"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}