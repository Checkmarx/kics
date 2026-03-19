# Regla KICS: Endpoints de Metadatos Legacy Deshabilitados en Instancias de OCI

## Descripción General

Esta regla de KICS para Terraform asegura que todas las instancias de cómputo de OCI (`oci_core_instance`) tengan los endpoints del servicio de metadatos legacy (IMDSv1) deshabilitados.

El servicio de metadatos de instancia (IMDS) permite a una instancia obtener información sobre sí misma. La versión 1 (legacy) es vulnerable a ataques de tipo SSRF (Server-Side Request Forgery). La versión 2 (IMDSv2) introduce protecciones que mitigan este riesgo. Deshabilitar los endpoints legacy y forzar el uso de IMDSv2 es una práctica de seguridad fundamental para proteger las instancias.

## Lógica de la Regla

La política verifica la presencia y configuración del atributo `are_legacy_imds_endpoints_disabled` dentro del bloque `agent_config`.

## Casos de Fallo Detectados

A continuación se describen los tres escenarios que esta política detectará.

---
### Caso 1: Bloque `agent_config` Ausente

* **Descripción:** El recurso `oci_core_instance` no define el bloque `agent_config`. Por defecto, esto implica que la configuración de seguridad no está aplicada.
* **Ejemplo:**
    ```terraform
    resource "oci_core_instance" "test" {
      # Falta el bloque agent_config
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `oci_core_instance`.

---
### Caso 2: Atributo Ausente en `agent_config`

* **Descripción:** El bloque `agent_config` existe, pero no contiene el atributo `are_legacy_imds_endpoints_disabled`. El valor por defecto es `false` (inseguro).
* **Ejemplo:**
    ```terraform
    resource "oci_core_instance" "test" {
      agent_config {
        # Falta el atributo are_legacy_imds_endpoints_disabled
        is_monitoring_disabled = false
      }
    }
    ```
* **Ubicación de la Alerta:** Bloque `agent_config`.

---
### Caso 3: Atributo Configurado como `false`

* **Descripción:** El atributo `are_legacy_imds_endpoints_disabled` está presente pero explícitamente configurado como `false`, habilitando los endpoints legacy inseguros.
* **Ejemplo:**
    ```terraform
    resource "oci_core_instance" "test" {
      agent_config {
        are_legacy_imds_endpoints_disabled = false # <-- ¡PROBLEMA!
      }
    }
    ```
* **Ubicación de la Alerta:** Línea del atributo `are_legacy_imds_endpoints_disabled`.

## Recurso Involucrado

* `oci_core_instance`

## Solución

```terraform
resource "oci_core_instance" "test_instance_correct" {
  # ... otros atributos ...
  
  agent_config {
    are_legacy_imds_endpoints_disabled = true
  }
}