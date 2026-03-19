# Regla KICS: Notificación para Cambios en Políticas de IAM en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para monitorizar y generar alertas ante cualquier cambio (creación, actualización o eliminación) en las políticas de IAM de la cuenta de OCI.

Las políticas de IAM son el mecanismo central que define "quién puede hacer qué" en OCI. Un cambio no autorizado en una política puede conceder permisos excesivos, eliminar controles de seguridad o abrir la puerta a un atacante para que tome el control de los recursos. La monitorización en tiempo real de estos cambios es, por tanto, una de las auditorías de seguridad más importantes.

## Lógica de la Regla

La política valida que exista una configuración activa para capturar los tres eventos críticos de políticas:
1.  `com.oraclecloud.identity.createpolicy`
2.  `com.oraclecloud.identity.updatepolicy`
3.  `com.oraclecloud.identity.deletepolicy`

## Casos de Fallo Detectados

---
### Caso 1: Regla Ausente (Missing)
* **Descripción:** No se encuentra ninguna regla de eventos que monitorice cambios en políticas de IAM en todo el proyecto.
* **Ubicación:** Bloque `provider "oci"`.

---
### Caso 2: Regla Incompleta (Incomplete)
* **Descripción:** Existe una regla que monitoriza algunos eventos de políticas (ej. `createpolicy`), pero omite otros críticos (ej. `deletepolicy`).
* **Ubicación:** Atributo `condition` del recurso.

---
### Caso 3: Regla Deshabilitada (Disabled)
* **Descripción:** Existe una regla completa con todos los eventos, pero está explícitamente deshabilitada (`is_enabled = false`).
* **Ubicación:** Atributo `is_enabled`.

## Recurso Involucrado

* `oci_events_rule`

## Solución

```terraform
resource "oci_events_rule" "iam_policy_change_rule" {
  display_name   = "audit-rule-for-iam-policy-changes"
  description    = "Alerts on any creation, update, or deletion of IAM policies"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  condition = jsonencode({
    eventType = [
      "com.oraclecloud.identity.createpolicy",
      "com.oraclecloud.identity.updatepolicy",
      "com.oraclecloud.identity.deletepolicy"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}

resource "oci_ons_notification_topic" "security_alerts_topic" {
  compartment_id = var.compartment_id
  name           = "security-alerts-topic"
}