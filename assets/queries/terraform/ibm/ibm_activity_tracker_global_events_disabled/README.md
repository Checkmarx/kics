# Regla KICS: Log de Auditoría para IBM Cloud IAM (Activity Tracker)

## Descripción General

Esta regla de KICS para Terraform asegura que una instancia de IBM Cloud Activity Tracker esté configurada para capturar eventos de auditoría, especialmente los eventos globales relacionados con la gestión de identidades y accesos (IAM).

IBM Cloud genera eventos de auditoría para acciones críticas en la cuenta (creación de usuarios, cambios de políticas, etc.). Para que estos eventos sean registrados y retenidos, se debe provisionar un servicio `activity-tracker`. Además, para capturar eventos que ocurren a nivel de cuenta (globales), la instancia de Activity Tracker debe estar ubicada en una región específica designada por IBM como "región de eventos globales". Sin esta configuración, las acciones de los administradores sobre IAM podrían no quedar registradas, dificultando investigaciones forenses o auditorías de cumplimiento.

## Lógica de la Regla

La política se compone de dos reglas que verifican la configuración de Activity Tracker:
1.  **Validación Global:** Confirma que al menos una instancia de `activity-tracker` exista en la configuración.
2.  **Validación de Ubicación:** Si existen instancias, confirma que su atributo `location` corresponda a una región compatible con eventos globales. Las regiones soportadas son: `eu-de` (Frankfurt), `eu-gb` (Londres), `us-south` (Dallas) y `au-syd` (Sídney).

## Casos de Fallo Detectados

A continuación se describen los dos escenarios que esta política detectará.

---

### Caso 1: Instancia de `activity-tracker` Ausente

* **Descripción:** Esta regla se activa si no existe ningún recurso `ibm_resource_instance` en la configuración de Terraform que tenga el atributo `service` configurado como `"activity-tracker"`. Esto significa que no se está capturando ningún log de auditoría en la cuenta.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    # El proyecto contiene varios recursos, pero ninguno define el servicio 'activity-tracker'.
    resource "ibm_is_vpc" "example" {
      name = "my-vpc"
    }
    ```
* **Ubicación de la Alerta:** La alerta será general y se anclará al bloque `provider "ibm" {}` indicando la ausencia del recurso.

---

### Caso 2: Instancia en una Región de Eventos Globales Incorrecta

* **Descripción:** Esta regla se activa si el recurso `activity-tracker` tiene su atributo `location` configurado en una región que no está designada por IBM para recibir eventos globales. Esto resultaría en la pérdida de visibilidad sobre los eventos de IAM.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_resource_instance" "activity_tracker_wrong_region" {
      name     = "my-activity-tracker"
      service  = "activity-tracker"
      plan     = "lite"
      location = "us-east" # <-- ¡PROBLEMA! No es una región de eventos globales.
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará específicamente al atributo `location` de la instancia de Activity Tracker incorrecta.

## Recurso Involucrado

* `ibm_resource_instance`

## Solución

Para solucionar los problemas detectados, asegúrate de que exista al menos un recurso `ibm_resource_instance` para el servicio `activity-tracker` y que su atributo `location` esté configurado en una de las regiones de eventos globales soportadas (Frankfurt, Londres, Dallas o Sídney).

```terraform
resource "ibm_resource_instance" "activity_tracker_correct" {
  name     = "my-global-activity-tracker"
  service  = "activity-tracker"
  plan     = "lite"
  
  # 'eu-de' es una de las regiones que soportan eventos globales.
  location = "eu-de" 
}