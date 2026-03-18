# Regla KICS: Notificación para Cambios en Tablas de Enrutamiento en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para monitorizar y generar alertas ante cualquier cambio (creación, actualización o eliminación) en las Tablas de Enrutamiento (Route Tables) de la cuenta de OCI.

Las tablas de enrutamiento controlan el flujo del tráfico de red entre subredes . Un cambio no autorizado podría redirigir el tráfico maliciosamente.

## Lógica de la Regla

La política verifica que exista configuración activa para capturar los tres tipos de eventos críticos de Route Tables:
1. `com.oraclecloud.virtualnetwork.createroutetable`
2. `com.oraclecloud.virtualnetwork.updateroutetable`
3. `com.oraclecloud.virtualnetwork.deleteroutetable`

## Casos de Fallo Detectados

### Caso 1: Regla Ausente (Missing)
* **Descripción:** No existe ninguna regla configurada para Route Tables en el proyecto.
* **Ubicación de la Alerta:** Bloque `provider "oci"`.

### Caso 2: Regla Incompleta (Incomplete)
* **Descripción:** Existe una regla para Route Tables, pero le faltan eventos (ej. monitoriza create pero olvida delete).
* **Ubicación de la Alerta:** Atributo `condition`.

### Caso 3: Regla Deshabilitada (Disabled)
* **Descripción:** Existe una regla relevante pero está explícitamente deshabilitada (`is_enabled = false`).
* **Ubicación de la Alerta:** Atributo `is_enabled` dentro del recurso.

## Solución

```terraform
resource "oci_events_rule" "route_table_change_rule" {
  display_name   = "audit-rule-for-route-table-changes"
  description    = "Alerts on any creation, update, or deletion of Route Tables"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  condition = jsonencode({
    eventType = [
      "com.oraclecloud.virtualnetwork.createroutetable",
      "com.oraclecloud.virtualnetwork.updateroutetable",
      "com.oraclecloud.virtualnetwork.deleteroutetable"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}