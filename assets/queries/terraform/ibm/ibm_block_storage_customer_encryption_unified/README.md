# Regla KICS: IBM Block Storage Encryption (CMK/BYOK/KYOK) Manual

## Descripción General

Esta regla unificada (INFO) audita los volúmenes de almacenamiento en bloque (`ibm_is_volume`) en IBM Cloud VPC para asegurar que utilizan estrategias de cifrado gestionadas por el cliente.

Cubre tres controles de seguridad distintos pero técnicamente equivalentes en la configuración de Terraform:
1.  **CMK (Customer Managed Key):** Uso de claves raíz almacenadas en Key Protect estándar.
2.  **BYOK (Bring Your Own Key):** Uso de material de clave generado por el cliente e importado a IBM Cloud.
3.  **KYOK (Keep Your Own Key):** Uso de Hyper Protect Crypto Services (HSM dedicado con certificación FIPS 140-2 Nivel 4).

La presencia del argumento `encryption_key` es el requisito técnico indispensable para habilitar cualquiera de estos tres modelos de control de claves sobre el almacenamiento.

## Lógica de la Regla

La política realiza las siguientes comprobaciones:
1.  Identifica todos los recursos de tipo `ibm_is_volume`.
2.  Verifica si el atributo `encryption_key` está ausente en la definición del recurso.
3.  Si falta, genera una alerta informativa indicando que el volumen está utilizando el cifrado por defecto (claves gestionadas por IBM), lo cual puede no satisfacer requisitos de cumplimiento de alto nivel.

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso 1: Cifrado por Defecto (Provider-Managed)

* **Descripción:** El volumen de bloque ha sido definido sin asignar una clave de cifrado específica. Aunque los datos están cifrados en reposo, las claves son controladas automáticamente por IBM Cloud.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_is_volume" "example_default_enc" {
      name    = "my-volume"
      profile = "10iops-tier"
      zone    = "us-south-1"
      
      # Falta el atributo 'encryption_key'
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará directamente al bloque del recurso `ibm_is_volume`.

## Recurso Involucrado

* `ibm_is_volume`

## Solución

Para cumplir con políticas de CMK, BYOK o KYOK, debes asignar el CRN (Cloud Resource Name) de una clave raíz válida proveniente de Key Protect o Hyper Protect Crypto Services.

```terraform
resource "ibm_is_volume" "secure_volume" {
  name           = "data-volume"
  profile        = "general-purpose"
  zone           = "us-south-1"
  
  # Habilitar Cifrado por el Cliente (Cubre CMK, BYOK y KYOK)
  encryption_key = "crn:v1:bluemix:public:kms:us-south:a/aaaaaa:bbbbbb:key:cccccc"
}