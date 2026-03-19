# Regla KICS: Notificación para Cambios en Listas de Seguridad en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para monitorizar y generar alertas ante cualquier cambio (creación, actualización o eliminación) en las Listas de Seguridad (Security Lists) de la cuenta de OCI.

Las Listas de Seguridad actúan como un firewall virtual a nivel de subred. Un cambio no autorizado, como añadir una regla que permita el acceso desde cualquier IP (`0.0.0.0/0`) a un puerto de gestión, puede exponer gravemente la infraestructura.

## Lógica de la Regla

La política verifica la configuración de los recursos `oci_events_rule` buscando los tres tipos de eventos fundamentales:
* `com.oraclecloud.virtualnetwork.createsecuritylist`
* `com.oraclecloud.virtualnetwork.updatesecuritylist`
* `com.oraclecloud.virtualnetwork.deletesecuritylist`

## Casos de Fallo Detectados

### Caso 1: Regla Ausente (Missing)
* **Descripción:** No existe ninguna regla en la configuración que monitorice cambios en Security Lists.
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
resource "oci_events_rule" "security_list_change_rule" {
  display_name   = "audit-rule-for-security-list-changes"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  condition = jsonencode({
    eventType = [
      "com.oraclecloud.virtualnetwork.createsecuritylist",
      "com.oraclecloud.virtualnetwork.updatesecuritylist",
      "com.oraclecloud.virtualnetwork.deletesecuritylist"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}