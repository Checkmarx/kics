# Regla KICS: Recursos Creados Fuera del Compartimento Raíz en OCI

## Descripción General

Esta regla de KICS para Terraform asegura que los recursos no se creen directamente en el compartimento raíz (también conocido como *tenancy*).

El compartimento raíz tiene los máximos privilegios y debe mantenerse lo más limpio posible, conteniendo únicamente otros compartimentos y políticas de IAM a nivel de *tenancy*. Crear recursos operativos (como instancias de cómputo, redes virtuales o bases de datos) en el compartimento raíz viola los principios de **menor privilegio**.

## Lógica de la Regla

La política mantiene una lista interna de tipos de recursos auditables. Itera sobre todos los recursos definidos en la configuración de Terraform y, si un recurso es de un tipo auditable, verifica el valor de su `compartment_id`.

La regla se activa si el `compartment_id` apunta al compartimento raíz. Esto se detecta de dos maneras:
1. Si el valor es una referencia a `var.tenancy_ocid`.
2. Si el propio valor del OCID contiene la palabra `tenancy` (case-insensitive).

## Caso de Fallo Detectado

### Caso Único: Recurso con `compartment_id` apuntando al Raíz
* **Descripción:** Un recurso de la lista auditable tiene su `compartment_id` asignado al OCID del *tenancy*.
* **Ubicación de la Alerta:** Atributo `compartment_id`.

## Solución

Asegúrate de que todos los recursos se creen en compartimentos hijos apropiados.

```terraform
variable "networking_compartment_ocid" {}

# Esta VCN se crea en un compartimento hijo dedicado, lo cual es correcto.
resource "oci_core_vcn" "example_vcn_correct" {
  compartment_id = var.networking_compartment_ocid
  display_name   = "VcnInNetworkingCompartment"
  cidr_block     = "10.1.0.0/16"
}