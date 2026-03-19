# Regla KICS: OCI IAM Password Expiration (365 days)

## Descripción General

Esta regla (INFO) verifica que las contraseñas de los usuarios de IAM expiren en un plazo máximo de 365 días, alineándose con el **CIS Oracle Cloud Infrastructure Benchmark**.

La regla maneja dos escenarios distintos dependiendo de la arquitectura de identidad utilizada en OCI:

1.  **Identity Domains (Moderno):** Audita el recurso `oci_identity_domains_password_policy`. El atributo correcto para controlar la caducidad automática es `password_expires_after`.
2.  **IAM Clásico (Legacy):** Audita el recurso `oci_identity_authentication_policy`. Este recurso antiguo no permite configurar la expiración de contraseñas explícitamente a través de Terraform, por lo que requiere validación manual en la consola.

## Lógica de la Regla

1.  **Para Identity Domains (`oci_identity_domains_password_policy`):**
    * Verifica el atributo `password_expires_after`.
    * Si el valor es mayor a 365 -> **Fallo**.
    * Si el atributo no está definido -> **Fallo** (se asume configuración insegura/desconocida).

2.  **Para IAM Clásico (`oci_identity_authentication_policy`):**
    * Genera siempre una alerta **Manual (INFO)**, indicando al auditor que debe verificar la consola de OCI.

## Casos de Fallo Detectados

### Caso 1: Expiración Excesiva (Identity Domains)
* **Descripción:** La política define `password_expires_after` con un valor mayor a 365 días.
* **Ubicación:** Atributo `password_expires_after`.

### Caso 2: Atributo Faltante (Identity Domains)
* **Descripción:** Falta el atributo `password_expires_after`.
* **Ubicación:** Recurso `oci_identity_domains_password_policy`.

### Caso 3: Recurso Legacy (Manual Check)
* **Descripción:** Se utiliza `oci_identity_authentication_policy`.
* **Ubicación:** Recurso `oci_identity_authentication_policy`.

## Solución

Para **Identity Domains**, establece la caducidad en 365 días o menos.

```terraform
resource "oci_identity_domains_password_policy" "secure_policy" {
  # ... otros atributos ...
  idcs_endpoint = var.idcs_endpoint
  
  # Caducidad de contraseña en 90 días (Recomendado)
  password_expires_after = 90
  
  schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:extension:passwordState:User"]
}