# Regla KICS: Notificación para Cambios en Gateways de Red en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que exista una regla de eventos (`oci_events_rule`) configurada para monitorizar y generar alertas ante cualquier cambio (creación, actualización o eliminación) en los gateways de red de la cuenta de OCI.

Los gateways de red (Internet Gateway, NAT Gateway, Service Gateway, DRG, LPG) son los puntos de entrada y salida del tráfico de una VCN.

## Lógica de la Regla

La política verifica que exista configuración activa para capturar los 15 eventos relacionados con el ciclo de vida de:
* Internet Gateway
* NAT Gateway
* Service Gateway
* Dynamic Routing Gateway (DRG)
* Local Peering Gateway (LPG)

## Casos de Fallo Detectados

### Caso 1: Regla Ausente (Missing)
* **Descripción:** No existe ninguna regla configurada para gateways en el proyecto.
* **Ubicación:** Bloque `provider "oci"`.

### Caso 2: Regla Incompleta (Incomplete)
* **Descripción:** Existe una regla para gateways, pero le faltan tipos de eventos (ej. monitoriza Internet Gateway pero olvida DRG).
* **Ubicación:** Atributo `condition`.

### Caso 3: Regla Deshabilitada (Disabled)
* **Descripción:** Existe una regla relevante pero está explícitamente deshabilitada (`is_enabled = false`).
* **Ubicación:** Atributo `is_enabled`.

## Solución

```terraform
resource "oci_events_rule" "network_gateway_change_rule" {
  display_name   = "audit-rule-for-network-gateway-changes"
  description    = "Alerts on any creation, update, or deletion of Network Gateways"
  compartment_id = var.tenancy_ocid
  is_enabled     = true

  condition = jsonencode({
    eventType = [
      "com.oraclecloud.virtualnetwork.createinternetgateway",
      "com.oraclecloud.virtualnetwork.updateinternetgateway",
      "com.oraclecloud.virtualnetwork.deleteinternetgateway",
      "com.oraclecloud.virtualnetwork.createnatgateway",
      "com.oraclecloud.virtualnetwork.updatenatgateway",
      "com.oraclecloud.virtualnetwork.deletenatgateway",
      "com.oraclecloud.virtualnetwork.createservicegateway",
      "com.oraclecloud.virtualnetwork.updateservicegateway",
      "com.oraclecloud.virtualnetwork.deleteservicegateway",
      "com.oraclecloud.virtualnetwork.createdrg",
      "com.oraclecloud.virtualnetwork.updatedrg",
      "com.oraclecloud.virtualnetwork.deletedrg",
      "com.oraclecloud.virtualnetwork.createlocalpeeringgateway",
      "com.oraclecloud.virtualnetwork.updatelocalpeeringgateway",
      "com.oraclecloud.virtualnetwork.deletelocalpeeringgateway"
    ]
  })
  
  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.security_alerts_topic.id
    }
  }
}