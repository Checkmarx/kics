# Regla KICS: Notificación para Cambios en Grupos de IAM en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para monitorizar y generar alertas ante cualquier cambio (creación, actualización o eliminación) en los grupos de IAM de la cuenta de OCI.

Los grupos de IAM son la base de la gestión de permisos en OCI. Un atacante o un actor interno malicioso podría crear un nuevo grupo con altos privilegios, añadir usuarios a un grupo de administradores, o eliminar un grupo existente para causar una denegación de servicio. Monitorizar estos cambios en tiempo real es una medida de seguridad esencial para detectar escaladas de privilegios no autorizadas o manipulaciones en los controles de acceso.

## Lógica de la Regla

La política realiza un análisis exhaustivo en busca de reglas que capturen los siguientes tres tipos de eventos críticos de IAM:
1.  `com.oraclecloud.identity.creategroup`
2.  `com.oraclecloud.identity.updategroup`
3.  `com.oraclecloud.identity.deletegroup`

La validación se divide en tres comprobaciones específicas:
1.  **Existencia Global:** Verifica si existe al menos una regla en todo el proyecto que monitorice eventos de grupos IAM.
2.  **Integridad de la Condición:** Si la regla existe, verifica que incluya **los tres** tipos de eventos mencionados anteriormente.
3.  **Estado de la Regla:** Verifica que la regla, si está correctamente configurada, se encuentre habilitada (`is_enabled = true`).

## Casos de Fallo Detectados

A continuación se describen los tres escenarios específicos que esta política detectará.

---
### Caso 1: Regla de Eventos para Grupos IAM Totalmente Ausente

* **Descripción:** Esta regla se activa si en toda la configuración de Terraform no se encuentra ningún recurso `oci_events_rule` que haga referencia a eventos de grupos de IAM. Esto indica una falta total de auditoría sobre estos recursos.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    # El proyecto define recursos de infraestructura, pero carece de reglas de
    # eventos para seguridad de IAM.
    
    provider "oci" {
      region = "us-ashburn-1"
    }
    ```
* **Ubicación de la Alerta:** La alerta será general y se anclará al bloque `provider "oci" {}`.

---
### Caso 2: Regla de Eventos Incompleta (Faltan Tipos de Eventos)

* **Descripción:** Se ha detectado una regla `oci_events_rule` destinada a monitorizar grupos, pero su configuración es incompleta. La propiedad `condition` incluye algunos eventos (por ejemplo, solo la creación), pero omite otros críticos (como la eliminación o actualización).
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "oci_events_rule" "iam_group_partial" {
      display_name   = "audit-iam-create"
      is_enabled     = true
      
      # FALLO: Solo monitoriza la creación, ignorando actualizaciones y borrados.
      condition      = jsonencode({
        "eventType": ["com.oraclecloud.identity.creategroup"]
      })
      
      actions {
        # ... configuración de acciones ...
      }
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará específicamente al atributo `condition` dentro del recurso `oci_events_rule` afectado.

---
### Caso 3: Regla de Eventos Deshabilitada

* **Descripción:** Existe una regla `oci_events_rule` correctamente configurada que incluye todos los eventos de grupos de IAM necesarios, pero se encuentra explícitamente deshabilitada (`is_enabled = false`), por lo que no está protegiendo el entorno.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "oci_events_rule" "iam_group_disabled" {
      display_name   = "audit-iam-all"
      
      # FALLO: La regla está bien definida pero apagada.
      is_enabled     = false
      
      condition      = jsonencode({
        "eventType": [
          "com.oraclecloud.identity.creategroup",
          "com.oraclecloud.identity.updategroup",
          "com.oraclecloud.identity.deletegroup"
        ]
      })
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará al atributo `is_enabled` dentro del recurso.

## Recurso Involucrado

* `oci_events_rule`

## Solución

Para solucionar cualquiera de los problemas detectados, asegúrate de configurar un recurso `oci_events_rule` que incluya los tres eventos requeridos y esté habilitado.

```terraform
# RECURSO REQUERIDO PARA LA SOLUCIÓN
resource "oci_events_rule" "iam_group_change_rule" {
  display_name   = "audit-rule-for-iam-group-changes"
  description    = "Alerts on any creation, update, or deletion of IAM groups"
  compartment_id = var.tenancy_ocid # Los eventos de IAM suelen ser a nivel de Tenancy
  is_enabled     = true

  # La condición debe incluir explícitamente los tres tipos de eventos.
  condition = jsonencode({
    eventType = [
      "com.oraclecloud.identity.creategroup",
      "com.oraclecloud.identity.updategroup",
      "com.oraclecloud.identity.deletegroup"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}

# Recurso auxiliar: Tópico de notificación para enviar la alerta.
resource "oci_ons_notification_topic" "security_alerts_topic" {
  compartment_id = var.compartment_id
  name           = "security-alerts-topic"
}