# Regla KICS: VCN Flow Logging Habilitado

## Descripción General

Esta regla de KICS para Terraform asegura que todas las subredes de una VCN (Virtual Cloud Network) en OCI tengan el registro de flujos (`Flow Logging`) correctamente configurado y habilitado.

La monitorización del tráfico de red es crucial para la detección de anomalías y la resolución de incidentes, cumpliendo con las recomendaciones de seguridad CIS.

## Lógica de la Regla

La política se divide en cuatro comprobaciones:
1.  **Huérfano:** Subredes sin ningún recurso de log que las apunte.
2.  **Estado:** Logs de flujo marcados como `is_enabled = false`.
3.  **Tipo:** Logs de servicio que no usan el `log_type = "SERVICE"`.
4.  **Servicio:** Logs que no especifican `service = "flowlogs"` en su origen.

## Casos de Fallo Detectados

### Caso 1: Subred sin Log Asociado
* **Descripción:** Falta la definición del log para la subred.
* **Ubicación:** Recurso `oci_core_subnet`.

### Caso 2: Log de Flujo Deshabilitado
* **Descripción:** El atributo `is_enabled` está en `false`.
* **Ubicación:** Atributo `is_enabled` en `oci_logging_log`.

### Caso 3: Log de Flujo con el Tipo Incorrecto
* **Descripción:** `log_type` no es `"SERVICE"`.
* **Ubicación:** Atributo `log_type` en `oci_logging_log`.

### Caso 4: Log de Flujo con el Servicio Incorrecto
* **Descripción:** El servicio configurado no es `"flowlogs"`.
* **Ubicación:** Atributo `service` dentro del bloque `source`.

## Recursos Involucrados

* `oci_core_subnet`
* `oci_logging_log`

## Solución

```terraform
resource "oci_logging_log" "vcn_flow_log" {
  display_name = "subnet_flow_log"
  log_group_id = oci_logging_log_group.example_log_group.id
  log_type     = "SERVICE"
  is_enabled   = true

  configuration {
    source {
      resource = oci_core_subnet.example_subnet.id
      service  = "flowlogs"
      category = "all"
    }
  }
}