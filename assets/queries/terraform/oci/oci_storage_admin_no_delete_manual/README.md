# Regla KICS: OCI Storage Admin with Delete Privileges (Manual)

## Descripción General

Esta regla informativa (INFO) audita las políticas de IAM (`oci_identity_policy`) para identificar administradores de almacenamiento con permisos excesivos, específicamente la capacidad de borrar recursos.

En OCI, el verbo **`manage`** incluye todos los permisos: `inspect`, `read`, `use`, `create`, `update` y **`DELETE`**. Para cumplir con controles estrictos de protección de datos, los administradores de almacenamiento no deberían tener capacidad para eliminar volúmenes o buckets por defecto, o esta capacidad debería estar restringida mediante condiciones.

## Lógica de la Regla

1.  Analiza las sentencias (`statements`) de las políticas.
2.  Busca la combinación del verbo exacto `manage` con familias de almacenamiento:
    * `object-family`
    * `volume-family`
    * `file-family`
    * `autonomous-database-family`
3.  Genera una alerta INFO para revisión manual si se detecta acceso total de gestión.

## Casos de Fallo Detectados

### Caso 1: Gestión Total de Almacenamiento
* **Descripción:** Se otorga `manage` sobre una familia de almacenamiento sin restricciones visibles en la sentencia.
* **Acción:** Verificar si el usuario realmente requiere capacidad de borrado o si se puede añadir una cláusula `where request.permission != 'DELETE'`.

## Recursos Involucrados
* `oci_identity_policy`

## Solución

Añade una condición a la política para restringir el borrado.

```terraform
resource "oci_identity_policy" "storage_admin_safe" {
  name           = "SafeStorageAdmin"
  compartment_id = var.tenancy_ocid
  statements = [
    # Permite gestionar todo EXCEPTO borrar
    "Allow group StorageAdmins to manage object-family in tenancy where request.permission != 'DELETE'"
  ]
}