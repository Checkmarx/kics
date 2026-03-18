# Regla KICS: Tags por Defecto Definidos en OCI

## Descripción General

Esta regla de KICS para Terraform verifica que se haya definido una política de etiquetado por defecto en la configuración de OCI. La gestión de esta política se realiza a través del recurso `oci_identity_tag_default`.

El uso de tags por defecto es una práctica de gobernanza fundamental en la nube. Permite asegurar que todos los recursos creados dentro de un compartimento específico reciban automáticamente un conjunto predefinido de etiquetas. Esto es esencial para la gestión de costes, la automatización de procesos, el control de acceso y la auditoría.

## Lógica de la Regla

La política implementa una única regla para verificar la existencia de al menos un recurso `oci_identity_tag_default` en toda la configuración de Terraform. Si no se encuentra ninguno, se asume que no se está gestionando una política de etiquetado por defecto.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---
### Caso Único: Recurso `oci_identity_tag_default` Ausente

* **Descripción:** Esta regla se activa si en toda la configuración de Terraform no se encuentra ni un solo recurso de tipo `oci_identity_tag_default`.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    # El proyecto contiene varios recursos de OCI, pero ninguno define
    # una política de tags por defecto.
    
    resource "oci_core_vcn" "example_vcn" {
      compartment_id = var.compartment_id
      # ...
    }
    ```
* **Ubicación de la Alerta:** La alerta será general y se anclará al bloque `provider "oci" {}` para indicar que falta un recurso `oci_identity_tag_default` en la configuración global.

## Recurso Involucrado

* `oci_identity_tag_default`

## Solución

Para solucionar el problema detectado, asegúrate de que tu configuración de Terraform incluya al menos un recurso `oci_identity_tag_default`. Este recurso requiere que primero se defina un `oci_identity_tag_namespace` y un `oci_identity_tag`.

```terraform
# Es necesario definir un espacio de nombres para los tags.
resource "oci_identity_tag_namespace" "example_ns" {
  compartment_id = var.compartment_id
  description    = "Namespace for default tags"
  name           = "example-namespace"
}

# Es necesario definir el tag que se usará por defecto.
resource "oci_identity_tag" "example_tag" {
  tag_namespace_id = oci_identity_tag_namespace.example_ns.id
  description      = "Tag for cost center"
  name             = "CostCenter"
}

# RECURSO REQUERIDO PARA LA SOLUCIÓN
resource "oci_identity_tag_default" "example_default_tag" {
  compartment_id = var.compartment_id
  
  # ID del tag que se aplicará por defecto.
  tag_definition_id = oci_identity_tag.example_tag.id
  
  # Valor que se aplicará por defecto.
  value = "IT-DEPT-123"

  # Asegura que los usuarios no puedan sobreescribir este valor por defecto.
  is_required = true
}
```