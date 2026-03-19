# Regla KICS: Versionado Habilitado para Buckets de Object Storage en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que todos los buckets de OCI Object Storage (`oci_objectstorage_bucket`) tengan habilitada la funcionalidad de versionado.

El versionado es una capa de protección de datos fundamental. Cuando está habilitado, cualquier modificación (sobrescritura) o eliminación de un objeto no lo destruye permanentemente, sino que crea una nueva versión o un marcador de eliminación. Esto permite recuperar fácilmente versiones anteriores de un objeto en caso de un borrado accidental o una modificación no deseada, actuando como una red de seguridad contra la pérdida de datos.

## Lógica de la Regla

La política se compone de dos reglas para cubrir los escenarios en los que el versionado está desactivado, centradas en el atributo `versioning`.

## Casos de Fallo Detectados

### Caso 1: Atributo `versioning` Ausente

* **Descripción:** Esta regla detecta cualquier recurso `oci_objectstorage_bucket` donde el atributo `versioning` no está definido. Si se omite, el versionado no se habilita por defecto.
* **Ubicación de la Alerta:** Recurso `oci_objectstorage_bucket`.

### Caso 2: Atributo `versioning` no es `Enabled`

* **Descripción:** Esta regla busca un recurso `oci_objectstorage_bucket` que tiene el atributo `versioning` explícitamente configurado con un valor diferente a `"Enabled"` (por ejemplo, `"Suspended"` o `"Disabled"`).
* **Ubicación de la Alerta:** Atributo `versioning`.

## Solución

Para solucionar los problemas detectados, asegúrate de que cada recurso `oci_objectstorage_bucket` incluya el atributo `versioning` con el valor `"Enabled"`.

```terraform
resource "oci_objectstorage_bucket" "example" {
  # ... otros atributos ...
  
  versioning = "Enabled"
}