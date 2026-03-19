# Regla KICS: Logging de Escritura en OCI Object Storage

## Descripción General

Esta regla de KICS para Terraform asegura que todos los buckets de OCI Object Storage (`oci_objectstorage_bucket`) tengan habilitada la emisión de eventos para objetos. Esta funcionalidad es fundamental para el logging de operaciones de escritura, como la creación (`put`), sobreescritura y eliminación de objetos.

Auditar quién modifica o elimina datos es un requisito de seguridad y cumplimiento normativo crítico. Esta política verifica los dos escenarios posibles de mala configuración para proporcionar alertas precisas.

## Lógica de la Regla

La política se compone de dos reglas especializadas que cubren todos los casos en los que el logging de eventos de objeto está desactivado.

## Casos de Fallo Detectados

### Caso 1: Atributo `object_events_enabled` Ausente

* **Descripción:** Esta regla detecta cualquier recurso `oci_objectstorage_bucket` donde el atributo `object_events_enabled` no está definido. El valor por defecto es `false`.
* **Ubicación de la Alerta:** Recurso `oci_objectstorage_bucket`.

### Caso 2: Atributo `object_events_enabled` es `false`

* **Descripción:** Esta regla busca un recurso `oci_objectstorage_bucket` que tiene el atributo `object_events_enabled` explícitamente configurado como `false`.
* **Ubicación de la Alerta:** Atributo `object_events_enabled`.

## Solución

Para solucionar los problemas detectados por esta regla, asegúrate de que cada recurso `oci_objectstorage_bucket` incluya la siguiente línea:

```terraform
resource "oci_objectstorage_bucket" "example" {
  # ... otros atributos ...
  
  object_events_enabled = true
}