# Regla KICS: GKE Secrets Not Encrypted with CMEK

## Descripción General

Esta regla de severidad **ALTA** verifica que los clústeres de GKE tengan habilitado el cifrado de secretos en la capa de aplicación mediante una clave de **Cloud KMS** gestionada por el cliente (**CMEK**).

Por defecto, GKE cifra los datos en reposo a nivel de disco, pero los secretos de Kubernetes almacenados en la base de datos `etcd` requieren una capa de protección adicional. Al habilitar esta función, GKE utiliza una clave de cifrado de sobres (envelope encryption) donde una Clave de Cifrado de Datos (DEK) cifra el secreto, y dicha DEK es cifrada por una Clave de Cifrado de Claves (KEK) alojada en Cloud KMS. Esto permite que el cliente tenga soberanía absoluta sobre sus secretos, pudiendo revocar el acceso a los mismos instantáneamente inhabilitando la clave en KMS.

## Lógica de la Regla

La política audita el recurso `google_container_cluster` evaluando tres fallos de seguridad:
1.  **Omisión:** No se define el bloque `database_encryption`.
2.  **Desactivación:** El estado de cifrado se establece explícitamente en `DECRYPTED`.
3.  **Configuración Incompleta:** Se activa el cifrado pero no se proporciona el identificador de la clave (`key_name`).

## Casos de Fallo Detectados

---

### Caso 1: Configuración de Cifrado Ausente
* **Descripción:** El clúster se aprovisiona sin la capa de protección para secretos en etcd.
* **Ubicación de la Alerta:** Bloque del recurso `google_container_cluster`.

### Caso 2: Cifrado Deshabilitado
* **Descripción:** Se configura el bloque pero el estado se marca como no cifrado.
* **Ubicación de la Alerta:** Atributo `state` dentro de `database_encryption`.

### Caso 3: Clave KMS Faltante
* **Descripción:** Se intenta cifrar pero no se referencia ninguna clave válida de Cloud KMS.
* **Ubicación de la Alerta:** Atributo `key_name` dentro de `database_encryption`.

## Recurso Involucrado

* `google_container_cluster`

## Solución

Configure el bloque `database_encryption` con el estado `ENCRYPTED` y asigne el recurso de clave correspondiente.

```terraform
resource "google_container_cluster" "secure_cluster" {
  name     = "production-cluster"
  location = "us-central1"

  # Solución técnica
  database_encryption {
    state    = "ENCRYPTED"
    key_name = "projects/my-project/locations/global/keyRings/my-ring/cryptoKeys/my-key"
  }
}