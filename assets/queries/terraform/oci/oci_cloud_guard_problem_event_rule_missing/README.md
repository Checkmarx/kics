# Regla KICS: Notificación para Problemas Detectados por Cloud Guard en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para generar notificaciones cuando OCI Cloud Guard detecta un nuevo "problema".

Habilitar Cloud Guard es solo el primer paso; su efectividad real depende de la capacidad del equipo de seguridad para responder a sus hallazgos. Si los problemas que Cloud Guard detecta no generan notificaciones automáticas, las alertas críticas pueden pasar desapercibidas durante un tiempo considerable, retrasando la mitigación de riesgos y aumentando la exposición.

## Lógica de la Regla

La política implementa una búsqueda **global** en todo el proyecto Terraform (analizando todos los archivos `.tf` simultáneamente).

Inspecciona todos los recursos `oci_events_rule` definidos en la infraestructura para verificar si **al menos uno** de ellos cumple las siguientes condiciones:
1.  Está habilitado (`is_enabled = true`).
2.  Su condición de filtrado incluye el tipo de evento específico: `com.oraclecloud.cloudguard.problem`.

Si no se encuentra ninguna regla que cumpla ambos requisitos en todo el proyecto, se genera una alerta.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---
### Caso Único: Regla de Eventos para Problemas de Cloud Guard Ausente o Mal Configurada

* **Descripción:** Esta regla se activa si en toda la configuración del proyecto no se encuentra ningún recurso `oci_events_rule` habilitado que capture el evento de Cloud Guard. Esto incluye casos donde la regla no existe, o existe pero monitoriza eventos diferentes.
* **Ubicación de la Alerta:** La alerta se anclará al bloque `provider "oci" {}`, indicando que falta una configuración global de seguridad.

* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    # El proyecto puede tener otras reglas de eventos, pero ninguna para
    # notificar los problemas detectados por Cloud Guard.

    resource "oci_events_rule" "example_rule_wrong_event" {
      display_name   = "rule-for-instance-events"
      compartment_id = var.compartment_id
      is_enabled     = true
      
      # FALLO: Esta condición monitoriza el lanzamiento de instancias, 
      # pero ignora los problemas de seguridad de Cloud Guard.
      condition      = "{\"eventType\":[\"com.oraclecloud.compute.instance.launch.end\"]}"
      
      actions {
        actions {
          action_type = "ONS"
          topic_id    = oci_ons_notification_topic.test_topic.id
        }
      }
    }
    ```

## Recurso Involucrado

* `oci_events_rule`

## Solución

Para solucionar el problema detectado, asegúrate de que tu configuración de Terraform incluya al menos un recurso `oci_events_rule` habilitado y configurado específicamente para el evento de problema de Cloud Guard.

Se recomienda filtrar por niveles de riesgo (CRITICAL, HIGH) para evitar ruido, como se muestra a continuación:

```terraform
# RECURSO REQUERIDO PARA LA SOLUCIÓN
resource "oci_events_rule" "cloud_guard_problem_rule" {
  display_name   = "notify-on-cloud-guard-problems"
  description    = "Sends a notification when Cloud Guard detects a new problem"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  # La condición busca el evento específico y filtra por severidad.
  condition = jsonencode({
    eventType = [
      "com.oraclecloud.cloudguard.problem"
    ],
    data = {
      "riskLevel" = [
        "CRITICAL",
        "HIGH"
      ]
    }
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