# Regla KICS: Notificación para Autenticación de Usuarios Locales en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para generar notificaciones cada vez que un usuario local de IAM (no federado) se autentica en la cuenta de OCI.

Los usuarios locales de IAM son aquellos definidos directamente en OCI. Monitorizar sus inicios de sesión es una medida de seguridad fundamental para detectar actividad sospechosa, como inicios de sesión desde ubicaciones inusuales o intentos de fuerza bruta.

## Lógica de la Regla

La política verifica que exista configuración activa para capturar el siguiente evento crítico:
* `com.oraclecloud.identity.localuser.authenticate`

## Casos de Fallo Detectados

### Caso 1: Regla Ausente (Missing)
* **Descripción:** No existe ninguna regla configurada para monitorear la autenticación de usuarios locales.
* **Ubicación de la Alerta:** Bloque `provider "oci"`.

### Caso 2: Regla Deshabilitada (Disabled)
* **Descripción:** Existe una regla que monitorea el evento correcto, pero está explícitamente deshabilitada (`is_enabled = false`).
* **Ubicación de la Alerta:** Atributo `is_enabled` dentro del recurso `oci_events_rule`.

## Solución

```terraform
resource "oci_events_rule" "local_user_auth_rule" {
  display_name   = "audit-rule-for-local-user-authentication"
  description    = "Alerts on any local IAM user authentication event"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  condition = jsonencode({
    eventType = [
      "com.oraclecloud.identity.localuser.authenticate"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}