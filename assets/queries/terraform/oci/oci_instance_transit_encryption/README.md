# Regla KICS: OCI Instance In-Transit Encryption Disabled

## Descripción General

Esta regla de severidad **MEDIA** audita el recurso `oci_core_instance` para verificar que el cifrado en tránsito esté habilitado.

En OCI, la opción `is_pv_encryption_in_transit_enabled` dentro de `launch_options` habilita el cifrado de los datos transferidos entre la instancia de computación y los volúmenes de arranque o de bloques paravirtualizados. Esto asegura la confidencialidad de los datos mientras viajan por la red interna del centro de datos.

## Lógica de la Regla

La regla verifica tres escenarios distintos:

1.  **Valor Incorrecto:** El bloque `launch_options` existe y el atributo `is_pv_encryption_in_transit_enabled` está explícitamente en `false`.
2.  **Atributo Faltante:** El bloque `launch_options` existe, pero falta el atributo `is_pv_encryption_in_transit_enabled` (lo que puede aplicar un valor por defecto inseguro).
3.  **Bloque Faltante:** No existe el bloque `launch_options` en la definición del recurso.

## Casos de Fallo Detectados

### Caso 1: Cifrado Deshabilitado Explícitamente
* **Descripción:** Se ha configurado `is_pv_encryption_in_transit_enabled = false`.
* **Ubicación de la Alerta:** Atributo `is_pv_encryption_in_transit_enabled`.

### Caso 2: Atributo Faltante en Opciones
* **Descripción:** El bloque `launch_options` está definido, pero no se especifica el cifrado, confiando en el valor predeterminado del proveedor.
* **Ubicación de la Alerta:** Bloque `launch_options`.

### Caso 3: Bloque de Opciones Ausente
* **Descripción:** La instancia no define `launch_options`, por lo que no se está forzando el cifrado en tránsito.
* **Ubicación de la Alerta:** Recurso `oci_core_instance`.

## Recurso Involucrado
* `oci_core_instance`

## Solución

Habilita explícitamente el cifrado en tránsito dentro de las opciones de lanzamiento.

```terraform
resource "oci_core_instance" "secure_instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.E4.Flex"
  
  # Bloque requerido para la seguridad en tránsito
  launch_options {
    boot_volume_type = "PARAVIRTUALIZED"
    is_pv_encryption_in_transit_enabled = true
  }

  source_details {
    source_type = "image"
    source_id   = var.image_id
  }
}