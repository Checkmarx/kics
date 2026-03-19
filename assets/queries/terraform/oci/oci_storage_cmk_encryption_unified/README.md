# Regla KICS: OCI Storage Resources Without CMK

## Descripción General

Esta regla unificada de severidad **MEDIA** audita los recursos de almacenamiento de OCI para asegurar que utilicen claves gestionadas por el cliente (CMK).

Aunque OCI cifra los datos en reposo por defecto, lo hace con claves gestionadas por Oracle. Para tener control total sobre el ciclo de vida de la clave (rotación, revocación), es necesario asignar una clave de **OCI Vault** mediante el atributo `kms_key_id`.

## Lógica de la Regla

La política verifica los siguientes recursos:
* `oci_objectstorage_bucket`
* `oci_core_volume`
* `oci_core_boot_volume`
* `oci_file_storage_file_system`

La regla se activa si:
1. El atributo `kms_key_id` no está definido.
2. El atributo `kms_key_id` está presente pero tiene un valor vacío.

## Casos de Fallo Detectados

### Caso 1: Cifrado por Defecto (Oracle-Managed)
* **Descripción:** El recurso no define `kms_key_id`, delegando el control de la clave a Oracle.
* **Ubicación de la Alerta:** Bloque del recurso.

### Caso 2: Configuración Vacía
* **Descripción:** Se define el atributo pero no se proporciona un OCID válido.
* **Ubicación de la Alerta:** Atributo `kms_key_id`.

## Solución

Asigna el OCID de una clave de OCI Vault al recurso.

```terraform
resource "oci_objectstorage_bucket" "secure_bucket" {
  name       = "secure-bucket"
  compartment_id = var.compartment_id
  kms_key_id = "ocid1.key.oc1.iad.exampleuniqueID"
}