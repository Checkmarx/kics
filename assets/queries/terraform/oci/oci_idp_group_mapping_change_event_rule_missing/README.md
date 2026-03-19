# Regla KICS: Notificación para Cambios de Mapeo de Grupos de IdP en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para monitorizar y generar alertas ante cambios en los mapeos de grupos de los proveedores de identidad (IdP) de la cuenta de OCI.

El mapeo de grupos de un IdP es lo que traduce la pertenencia a un grupo en un proveedor de identidad externo (como Azure AD, Okta, etc.) a la pertenencia a un grupo de IAM en OCI. Un cambio no autorizado en estos mapeos podría escalar privilegios de forma masiva y silenciosa.

## Lógica de la Regla

La política verifica que exista configuración activa para capturar el siguiente evento crítico:
* `com.oraclecloud.identitycontrolplane.updateidpgroupmapping`

## Casos de Fallo Detectados

### Caso 1: Regla Ausente (Missing)
* **Descripción:** No existe ninguna regla configurada para monitorear cambios en mapeos de grupos de IdP.
* **Ubicación de la Alerta:** Bloque `provider "oci"`.

### Caso 2: Regla Deshabilitada (Disabled)
* **Descripción:** Existe una regla que monitorea el evento correcto, pero está explícitamente deshabilitada (`is_enabled = false`).
* **Ubicación de la Alerta:** Atributo `is_enabled` dentro del recurso `oci_events_rule`.

## Solución

```terraform
resource "oci_events_rule" "iam_idp_group_mapping_change_rule" {
  display_name   = "audit-rule-for-idp-group-mapping-changes"
  description    = "Alerts on any modification to IdP group mappings"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  condition = jsonencode({
    eventType = [
      "com.oraclecloud.identitycontrolplane.updateidpgroupmapping"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}