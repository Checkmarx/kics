# Regla KICS: OCI IAM Password Minimum Length

## Descripción General

Esta regla automatizada (MEDIUM) audita el recurso `oci_identity_authentication_policy`.

Para garantizar una protección robusta contra ataques de fuerza bruta, el **CIS Oracle Cloud Infrastructure Benchmark** recomienda establecer la longitud mínima de la contraseña en **14 caracteres** o más.

El valor predeterminado de OCI (si no se especifica) suele ser de 12 caracteres, lo cual es insuficiente para los estándares actuales. Esta regla alerta si:
1.  La longitud se define explícitamente menor a 14.
2.  Falta el atributo de longitud (usa default).
3.  Falta el bloque de política de contraseñas completo (usa default).

## Lógica de la Regla

1.  Identifica el recurso `oci_identity_authentication_policy`.
2.  Verifica la existencia del bloque `password_policy`.
    * Si no existe el bloque -> **Fallo** (se usa configuración insegura por defecto).
3.  Si el bloque existe, verifica el atributo `minimum_password_length`:
    * Si el atributo falta -> **Fallo** (se usa configuración insegura por defecto).
    * Si el atributo es `< 14` -> **Fallo**.

## Casos de Fallo Detectados

### Caso 1: Longitud Insuficiente
* **Descripción:** Se ha configurado explícitamente `minimum_password_length` con un valor bajo (ej. 8 o 12).
* **Ubicación de la Alerta:** Atributo `minimum_password_length`.

### Caso 2: Atributo Faltante
* **Descripción:** El bloque existe, pero falta `minimum_password_length`, aplicando el default del proveedor.
* **Ubicación de la Alerta:** Bloque `password_policy`.

### Caso 3: Bloque Ausente
* **Descripción:** No se ha definido `password_policy` en absoluto.
* **Ubicación de la Alerta:** Recurso `oci_identity_authentication_policy`.

## Recurso Involucrado
* `oci_identity_authentication_policy`

## Solución

Define el bloque `password_policy` y establece explícitamente la longitud en al menos 14.

```terraform
resource "oci_identity_authentication_policy" "secure_policy" {
  compartment_id = var.tenancy_ocid

  password_policy {
    minimum_password_length = 14
    is_lowercase_characters_required = true
    is_uppercase_characters_required = true
    is_numeric_characters_required   = true
    is_special_characters_required   = true
  }
}