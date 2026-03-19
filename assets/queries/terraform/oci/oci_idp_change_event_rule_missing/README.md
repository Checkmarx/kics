# Regla KICS: Notificación para Cambios en el Proveedor de Identidad de OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para monitorizar y generar alertas ante cambios en los proveedores de identidad (Identity Providers) de la cuenta de OCI.

Los proveedores de identidad son un componente crítico de la seguridad, ya que controlan la federación de usuarios. Un atacante que consiga modificar o añadir un proveedor de identidad podría redirigir los inicios de sesión o federar un dominio malicioso para obtener acceso a la cuenta. Por lo tanto, cualquier cambio en esta configuración debe ser notificado y auditado inmediatamente.

## Lógica de la Regla

La política verifica que exista configuración activa para capturar el siguiente evento crítico:
* `com.oraclecloud.identitycontrolplane.updateidentityprovider`

## Casos de Fallo Detectados

### Caso 1: Regla Ausente (Missing)
* **Descripción:** No existe ninguna regla configurada para monitorear Identity Providers en el proyecto.
* **Ubicación de la Alerta:** Bloque `provider "oci"`.

### Caso 2: Regla Deshabilitada (Disabled)
* **Descripción:** Existe una regla que monitorea el evento correcto, pero está explícitamente deshabilitada (`is_enabled = false`).
* **Ubicación de la Alerta:** Atributo `is_enabled` dentro del recurso `oci_events_rule`.

## Solución

Para solucionar el problema, asegúrate de tener una regla habilitada con el evento correcto:

```terraform
resource "oci_events_rule" "iam_idp_change_rule" {
  display_name   = "audit-rule-for-identity-provider-changes"
  description    = "Alerts on any modification to Identity Providers"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  condition = jsonencode({
    eventType = [
      "com.oraclecloud.identitycontrolplane.updateidentityprovider"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}