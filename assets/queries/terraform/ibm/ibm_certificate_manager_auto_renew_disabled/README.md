# Regla KICS: Renovación Automática Habilitada para Certificados

## Descripción General

Esta regla de KICS para Terraform asegura que todos los certificados gestionados a través de IBM Cloud Certificate Manager (`ibm_cm_certificate`) tengan habilitada la funcionalidad de renovación automática.

La gestión manual de la caducidad de los certificados TLS es propensa a errores humanos, que pueden resultar en la caducidad de un certificado y causar interrupciones de servicio, errores de confianza y riesgos de seguridad. La renovación automática es una práctica recomendada para garantizar la continuidad del servicio y reducir la carga operativa de mantenimiento de seguridad.

## Lógica de la Regla

La política se compone de dos reglas especializadas para cubrir los casos en los que la renovación automática no está habilitada:
1.  **Atributo Faltante:** Identifica recursos donde no se define `auto_renew_enabled`, heredando el valor por defecto inseguro (`false`).
2.  **Valor Incorrecto:** Identifica recursos donde se ha desactivado explícitamente la renovación automática.

## Casos de Fallo Detectados

A continuación se describen los dos escenarios que esta política detectará.

---

### Caso 1: Atributo `auto_renew_enabled` Ausente

* **Descripción:** Esta regla detecta cualquier recurso `ibm_cm_certificate` donde el atributo `auto_renew_enabled` no está definido. Según la documentación del proveedor de Terraform para IBM, el valor por defecto de este atributo es `false`.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_cm_certificate" "cert_renew_missing" {
      instance_id = ibm_resource_instance.cm_instance.guid
      name        = "my-cert-renew-missing"
      
      # El atributo 'auto_renew_enabled' no está presente.
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará directamente al bloque de código del recurso `ibm_cm_certificate` al que le falta el atributo.

---

### Caso 2: Atributo `auto_renew_enabled` es `false`

* **Descripción:** Esta regla busca un recurso `ibm_cm_certificate` que tiene el atributo `auto_renew_enabled` explícitamente configurado como `false`.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_cm_certificate" "cert_renew_disabled" {
      instance_id = ibm_resource_instance.cm_instance.guid
      name        = "my-cert-renew-disabled"

      auto_renew_enabled = false # <-- ¡PROBLEMA!
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará específicamente a la línea `auto_renew_enabled = false` dentro del recurso `ibm_cm_certificate`.

## Recurso Involucrado

* `ibm_cm_certificate`

## Solución

Para solucionar los problemas detectados por esta regla, asegúrate de que cada recurso `ibm_cm_certificate` incluya el atributo habilitado:

```terraform
resource "ibm_cm_certificate" "cert_correct" {
  instance_id = ibm_resource_instance.cm_instance.guid
  name        = "my-secure-certificate"
  
  auto_renew_enabled = true
}