# Regla KICS: IBM Account Session Expiration Too Long

## Descripción General

Esta regla de severidad **MEDIA** verifica que la **Expiración de Sesión** en la configuración de la cuenta de IBM Cloud esté configurada de manera segura para mitigar riesgos de seguridad de identidad.

Por defecto, o si se configura de forma laxa, las sesiones de usuario pueden permanecer activas durante periodos prolongados (hasta 24 horas). Esto aumenta considerablemente la ventana de oportunidad para ataques de secuestro de sesión (Session Hijacking) y accesos no autorizados en terminales físicas compartidas. Según las mejores prácticas de la industria y el **CIS IBM Cloud Foundations Benchmark**, se recomienda limitar la duración de la sesión a **3600 segundos (1 hora)** o menos para forzar una re-autenticación periódica.

## Lógica de la Regla

La política audita el recurso `ibm_iam_account_settings` realizando dos comprobaciones:
1.  **Validación de Presencia:** Si falta el atributo `session_expiration_in_seconds`, la regla falla al asumir que la cuenta depende de valores por defecto inseguros.
2.  **Validación de Valor:** Si el valor configurado es numéricamente superior a `3600` segundos, la regla falla.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Configuración de Expiración Ausente
* **Descripción:** El recurso existe pero no define el tiempo de vida de la sesión, delegando el control al proveedor.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_iam_account_settings" "insecure_default" {
      mfa = "LEVEL2"
      # Falta session_expiration_in_seconds
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_iam_account_settings`.

---

### Caso 2: Tiempo de Sesión Excesivo
* **Descripción:** La sesión se ha configurado con una duración mayor a la hora recomendada (ej. 8 horas o 24 horas).
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_iam_account_settings" "too_long" {
      session_expiration_in_seconds = 28800 # 8 horas
    }
    ```
* **Ubicación de la Alerta:** Atributo `session_expiration_in_seconds`.

## Recurso Involucrado

* `ibm_iam_account_settings`

## Solución

Asegúrese de definir el límite de sesión en 3600 segundos o menos para cumplir con los estándares de seguridad.

```terraform
resource "ibm_iam_account_settings" "compliant_settings" {
  mfa                           = "LEVEL2"
  session_expiration_in_seconds = 3600 # 1 Hora
}