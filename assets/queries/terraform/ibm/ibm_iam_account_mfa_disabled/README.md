# Regla KICS: MFA Obligatorio a Nivel de Cuenta en IBM IAM

## Descripción General

Esta regla de KICS para Terraform asegura que la Autenticación Multi-Factor (MFA) esté habilitada y forzada a un nivel seguro para toda la cuenta de IBM Cloud. La configuración se gestiona a través del recurso `ibm_iam_account_settings`.

Forzar el uso de MFA es una de las medidas de seguridad más efectivas para proteger una cuenta contra el acceso no autorizado. Incluso si las credenciales (usuario y contraseña) de un administrador o usuario con privilegios son comprometidas, el MFA actúa como una barrera crítica de segundo nivel.

## Lógica de la Regla

La política se divide en tres comprobaciones complementarias para cubrir todos los escenarios de riesgo:
1.  **Ausencia de Recurso:** Verifica que exista el recurso de configuración de cuenta.
2.  **Atributo Faltante:** Verifica que el parámetro `mfa` esté definido explícitamente.
3.  **Nivel Inseguro:** Asegura que no se utilicen niveles débiles. Los niveles seguros aceptados son `LEVEL2` (TOTP/App de autenticación) y `LEVEL3` (U2F/Llave física).

## Casos de Fallo Detectados

A continuación se describen los tres escenarios que esta política detectará.

---

### Caso 1: Recurso `ibm_iam_account_settings` Ausente
* **Descripción:** No se está gestionando la política de la cuenta mediante código, dejando el MFA bajo configuración manual o por defecto (inseguro).
* **Ubicación:** Bloque `provider "ibm"`.

### Caso 2: Atributo `mfa` Ausente
* **Descripción:** El recurso de configuración existe pero no define el comportamiento del MFA.
* **Ubicación:** Recurso `ibm_iam_account_settings`.

### Caso 3: Valor de `mfa` Inseguro (`NONE` o `LEVEL1`)
* **Descripción:** El MFA está desactivado (`NONE`) o utiliza métodos débiles como email (`LEVEL1`).
* **Ubicación:** Atributo `mfa`.

## Recurso Involucrado

* `ibm_iam_account_settings`

## Solución

Para cumplir con esta política, define el recurso de configuración de cuenta y fuerza el uso de MFA de nivel 2 o superior.

```terraform
resource "ibm_iam_account_settings" "secure_iam_policy" {
  # Forzar el uso de TOTP (Time-based One-Time Password)
  mfa = "LEVEL2" 
}