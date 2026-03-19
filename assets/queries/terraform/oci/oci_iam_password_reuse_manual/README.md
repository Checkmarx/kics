# Regla KICS: OCI IAM Password Reuse Prevention (Manual)

## Descripción General

Esta regla informativa (INFO) audita las políticas de contraseñas en **Oracle Cloud Infrastructure (OCI)** para asegurar que se impida la reutilización de credenciales antiguas.

El **CIS Oracle Cloud Infrastructure Benchmark** recomienda configurar el historial de contraseñas para recordar las últimas **24** contraseñas utilizadas, evitando así que los usuarios alternen entre un conjunto pequeño de contraseñas conocidas.

La regla maneja dos escenarios distintos dependiendo de la arquitectura de identidad utilizada en OCI:

1.  **Identity Domains (Moderno):** Audita el recurso `oci_identity_domains_password_policy`. El atributo correcto para controlar el historial es `num_passwords_in_history`.
2.  **IAM Clásico (Legacy):** Audita el recurso `oci_identity_authentication_policy`. Este recurso antiguo no permite configurar el historial de contraseñas a través de Terraform, por lo que requiere validación manual en la consola.

## Lógica de la Regla

1.  **Para Identity Domains (`oci_identity_domains_password_policy`):**
    * Verifica el atributo `num_passwords_in_history`.
    * Si el valor es menor a 24 -> **Fallo**.
    * Si el atributo no está definido -> **Fallo** (se asume configuración insegura/desconocida).

2.  **Para IAM Clásico (`oci_identity_authentication_policy`):**
    * Genera siempre una alerta **Manual (INFO)**, indicando al auditor que debe verificar la consola de OCI.

## Casos de Fallo Detectados

### Caso 1: Historial Insuficiente (Identity Domains)
* **Descripción:** La política define `num_passwords_in_history` con un valor menor a 24 (ej. 5 o 10).
* **Ubicación de la Alerta:** Atributo `num_passwords_in_history`.

### Caso 2: Atributo Faltante (Identity Domains)
* **Descripción:** Falta el atributo `num_passwords_in_history`.
* **Ubicación de la Alerta:** Recurso `oci_identity_domains_password_policy`.

### Caso 3: Recurso Legacy (Manual Check)
* **Descripción:** Se utiliza `oci_identity_authentication_policy`.
* **Ubicación de la Alerta:** Recurso `oci_identity_authentication_policy`.

## Recursos Involucrados
* `oci_identity_domains_password_policy`
* `oci_identity_authentication_policy`

## Solución

Para **Identity Domains**, establece el historial en 24 o más.

```terraform
resource "oci_identity_domains_password_policy" "secure_policy" {
  idcs_endpoint = var.idcs_endpoint
  display_name  = "SecurePasswordPolicy"
  
  # Historial de contraseñas (CIS recomienda >= 24)
  num_passwords_in_history = 24
  
  schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:extension:passwordState:User"]
}