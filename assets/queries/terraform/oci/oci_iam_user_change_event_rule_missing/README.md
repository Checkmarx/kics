# Regla KICS: Notificación para Cambios en Usuarios de IAM en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para monitorizar y generar alertas ante cualquier cambio en el ciclo de vida de los usuarios de IAM en la cuenta de OCI.

La gestión de identidades de usuario es una superficie de ataque principal. Un atacante podría crear un usuario nuevo y oculto, modificar un usuario existente para escalar privilegios, o deshabilitar cuentas legítimas para causar una denegación de servicio.

## Lógica de la Regla

La política verifica que exista configuración activa para capturar los cinco tipos de eventos que constituyen el ciclo de vida de un usuario de IAM:
1. `com.oraclecloud.identity.createuser`
2. `com.oraclecloud.identity.updateuser`
3. `com.oraclecloud.identity.deleteuser`
4. `com.oraclecloud.identity.enableuser`
5. `com.oraclecloud.identity.disableuser`

## Casos de Fallo Detectados

### Caso 1: Regla Ausente (Missing)
* **Descripción:** No existe ninguna regla configurada para usuarios en el proyecto.
* **Ubicación:** Bloque `provider "oci"`.

### Caso 2: Regla Incompleta (Incomplete)
* **Descripción:** Existe una regla para usuarios, pero le faltan eventos (ej. monitorea `create` pero olvida `disable`).
* **Ubicación:** Atributo `condition`.

### Caso 3: Regla Deshabilitada (Disabled)
* **Descripción:** Existe una regla relevante pero está explícitamente deshabilitada (`is_enabled = false`).
* **Ubicación:** Atributo `is_enabled` dentro del recurso `oci_events_rule`.

## Solución

```terraform
resource "oci_events_rule" "iam_user_change_rule" {
  display_name   = "audit-rule-for-iam-user-changes"
  description    = "Alerts on any lifecycle change of IAM users"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  condition = jsonencode({
    eventType = [
      "com.oraclecloud.identity.createuser",
      "com.oraclecloud.identity.updateuser",
      "com.oraclecloud.identity.deleteuser",
      "com.oraclecloud.identity.enableuser",
      "com.oraclecloud.identity.disableuser"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}