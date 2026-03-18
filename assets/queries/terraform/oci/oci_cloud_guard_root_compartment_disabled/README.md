# Regla KICS: Cloud Guard Habilitado en el Compartimento Raíz de OCI

## Descripción General

Esta regla de KICS para Terraform asegura que el servicio OCI Cloud Guard esté habilitado (`status = "ENABLED"`) y configurado para operar a nivel del compartimento raíz (*tenancy*).

Cloud Guard es el servicio de gestión de la postura de seguridad (CSPM) nativo de OCI. Proporciona una visión centralizada de la seguridad, detecta configuraciones incorrectas y actividades anómalas, y puede automatizar la respuesta a problemas. Para obtener la máxima visibilidad y protección, IBM y Oracle recomiendan activarlo en el compartimento raíz, ya que sus políticas se heredan a todos los compartimentos hijos.

## Lógica de la Regla

La política se divide en tres reglas para cubrir todos los escenarios de mala configuración:
1. El recurso `oci_cloud_guard_configuration` no existe.
2. El recurso existe, pero su `status` no es `ENABLED`.
3. El recurso existe y está habilitado, pero no está asignado al compartimento raíz.

## Casos de Fallo Detectados

A continuación se describen los tres escenarios que esta política detectará.

---
### Caso 1: Recurso `oci_cloud_guard_configuration` Ausente

* **Descripción:** Esta regla se activa si no existe ningún recurso `oci_cloud_guard_configuration` en toda la configuración, lo que significa que Cloud Guard no está siendo gestionado por Terraform.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    # El proyecto no define ninguna configuración para Cloud Guard.
    ```
* **Ubicación de la Alerta:** La alerta se anclará al bloque `provider "oci" {}`.

---
### Caso 2: `status` de Cloud Guard no es `ENABLED`

* **Descripción:** Esta regla detecta un recurso `oci_cloud_guard_configuration` que existe, pero cuyo `status` es diferente de `"ENABLED"` (por ejemplo, `"DISABLED"`).
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "oci_cloud_guard_configuration" "cg_config_disabled" {
      compartment_id = var.tenancy_ocid
      reporting_region = "us-ashburn-1"
      status           = "DISABLED" # <-- ¡PROBLEMA!
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará directamente a la línea `status = "DISABLED"`.

---
### Caso 3: Cloud Guard no está en el Compartimento Raíz

* **Descripción:** Esta regla detecta un recurso `oci_cloud_guard_configuration` que está habilitado (`status = "ENABLED"`), pero su `compartment_id` no es el del *tenancy* (raíz). La regla identifica esto de forma heurística, comprobando que el OCID del compartimento no contenga la palabra `tenancy`.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "oci_cloud_guard_configuration" "cg_config_wrong_compartment" {
      # Apunta a un compartimento hijo en lugar del raíz.
      compartment_id = var.child_compartment_ocid # <-- ¡PROBLEMA!
      
      reporting_region = "us-ashburn-1"
      status           = "ENABLED"
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará directamente a la línea `compartment_id`.

## Recurso Involucrado

* `oci_cloud_guard_configuration`

## Solución

Para solucionar los problemas detectados, asegúrate de que exista un único recurso `oci_cloud_guard_configuration` con el `status` en `"ENABLED"` y el `compartment_id` apuntando al OCID del *tenancy* (compartimento raíz).

```terraform
resource "oci_cloud_guard_configuration" "cg_config_correct" {
  # El compartment_id debe ser el del tenancy para una cobertura completa.
  compartment_id = var.tenancy_ocid
  
  reporting_region = "us-ashburn-1"
  status           = "ENABLED"
}
```