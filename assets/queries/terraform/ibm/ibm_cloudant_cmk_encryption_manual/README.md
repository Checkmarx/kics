# Regla KICS: IBM Cloudant Encryption with CMK (Manual)

## Descripción General

Esta regla informativa (INFO) audita las instancias de **IBM Cloudant** desplegadas mediante el recurso genérico `ibm_resource_instance` para verificar el uso de claves gestionadas por el cliente.

Cloudant cifra los datos en reposo por defecto utilizando claves gestionadas por IBM. Sin embargo, para cumplir con requisitos de gestión de claves avanzada como **CMK** (Customer Managed Key) o **BYOK** (Bring Your Own Key), se debe inyectar el CRN (Cloud Resource Name) de una clave raíz proveniente de Key Protect o Hyper Protect Crypto Services.

En Terraform, esta configuración se realiza pasando el parámetro específico `key_protect_key` dentro del mapa de `parameters` del recurso. Si este mapa se omite o si la clave no está presente dentro de él, la instancia se provisionará con el cifrado estándar del proveedor.

## Lógica de la Regla

La política realiza las siguientes comprobaciones sobre recursos `ibm_resource_instance` donde el servicio es `"cloudantnosqldb"`:
1.  **Ausencia de Parámetros:** Detecta si el bloque `parameters` no ha sido definido en absoluto.
2.  **Parámetro Faltante:** Detecta si el bloque `parameters` existe pero no incluye la entrada `key_protect_key`.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Bloque de Parámetros Ausente

* **Descripción:** No se define ninguna configuración adicional, por lo que se asume el cifrado por defecto de IBM.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_resource_instance" "cloudant_no_params" {
      name     = "my-nosql-db"
      service  = "cloudantnosqldb"
      plan     = "standard"
      location = "us-south"
      # Falta el bloque parameters
    }
    ```
* **Ubicación de la Alerta:** Nivel del recurso `ibm_resource_instance`.

---

### Caso 2: Clave de Cifrado Faltante en Parámetros

* **Descripción:** Se definen parámetros pero se omite la clave de seguridad `key_protect_key`.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_resource_instance" "cloudant_partial_params" {
      name     = "my-nosql-db"
      service  = "cloudantnosqldb"
      plan     = "standard"
      location = "us-south"
      parameters = {
        "db_type" = "nosql"
      }
    }
    ```
* **Ubicación de la Alerta:** Atributo `parameters`.

## Recurso Involucrado

* `ibm_resource_instance` (Service: `cloudantnosqldb`)

## Solución

Añade el bloque `parameters` con la clave `key_protect_key` apuntando a un CRN válido.

```terraform
resource "ibm_resource_instance" "cloudant_secure" {
  name     = "my-secure-cloudant"
  service  = "cloudantnosqldb"
  plan     = "standard"
  location = "us-south"

  parameters = {
    key_protect_key = "crn:v1:bluemix:public:kms:us-south:a/aaaa:bbbb:key:cccc"
  }
}