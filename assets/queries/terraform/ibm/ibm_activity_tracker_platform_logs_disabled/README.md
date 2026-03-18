# Regla KICS: Logs de Plataforma Habilitados en Activity Tracker

## Descripción General

Esta regla de KICS para Terraform asegura que el servicio IBM Cloud Activity Tracker esté configurado para recibir y registrar los logs de gestión de la plataforma.

Los logs de plataforma (`platform_logs`) capturan eventos críticos a nivel de cuenta, como la gestión de usuarios y accesos (IAM), la facturación y la modificación de recursos, que son esenciales para una auditoría de seguridad completa y el cumplimiento normativo. Si esta opción no está habilitada, se pierde visibilidad sobre las acciones más importantes que ocurren en la cuenta, dejando puntos ciegos en la monitorización de seguridad.

## Lógica de la Regla

La política se divide en tres reglas especializadas para cubrir todos los escenarios en los que los logs de plataforma no están habilitados:
1.  **Existencia Global:** Verifica que al menos un Activity Tracker esté provisionado en la cuenta.
2.  **Atributo Faltante:** Verifica que el atributo `platform_logs` esté definido (ya que por defecto es `false`).
3.  **Valor Incorrecto:** Verifica que el atributo no esté explícitamente desactivado.

## Casos de Fallo Detectados

A continuación se describen los tres escenarios que esta política detectará.

---

### Caso 1: Instancia de `activity-tracker` Ausente

* **Descripción:** Esta regla se activa si no existe ningún recurso `ibm_resource_instance` con `service = "activity-tracker"`. Sin esta instancia, no hay ningún servicio que pueda recopilar los logs de la plataforma.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    # El proyecto de Terraform no define ninguna instancia para el servicio 'activity-tracker'.
    resource "ibm_is_vpc" "example" {
      name = "my-vpc"
    }
    ```
* **Ubicación de la Alerta:** La alerta será general y se anclará al bloque `provider "ibm" {}` para indicar que falta un recurso `activity-tracker` en la configuración global.

---

### Caso 2: Atributo `platform_logs` Ausente

* **Descripción:** Esta regla detecta una instancia de `activity-tracker` que existe, pero a la que le falta el atributo `platform_logs`. Según la documentación de Terraform para IBM Cloud, el valor por defecto de este atributo es `false`, por lo que su ausencia constituye una configuración insegura.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_resource_instance" "tracker_missing_attribute" {
      name     = "my-activity-tracker"
      service  = "activity-tracker"
      plan     = "lite"
      location = "eu-de"
      
      # El atributo 'platform_logs' no está presente.
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará directamente al bloque del recurso `ibm_resource_instance` al que le falta el atributo.

---

### Caso 3: Atributo `platform_logs` es `false`

* **Descripción:** Esta regla busca una instancia de `activity-tracker` que tiene el atributo `platform_logs` explícitamente configurado como `false`.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_resource_instance" "tracker_disabled_explicitly" {
      name          = "my-activity-tracker"
      service       = "activity-tracker"
      plan          = "lite"
      location      = "eu-de"

      platform_logs = false # <-- ¡PROBLEMA!
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará específicamente a la línea `platform_logs = false` dentro del recurso `ibm_resource_instance`.

## Recurso Involucrado

* `ibm_resource_instance`

## Solución

Para solucionar los problemas detectados, asegúrate de que exista al menos un recurso `ibm_resource_instance` para el servicio `activity-tracker` y que incluya la siguiente línea:

```terraform
resource "ibm_resource_instance" "activity_tracker_correct" {
  name          = "my-activity-tracker"
  service       = "activity-tracker"
  plan          = "lite"
  location      = "eu-de" # Región compatible con eventos globales

  platform_logs = true
}