# Regla KICS: IBM Account IP Restrictions (Manual)

## Descripción General

Esta regla informativa (INFO) audita la configuración global de la cuenta en IBM Cloud a través del recurso `ibm_iam_account_settings`.

Para mitigar el riesgo de compromiso de credenciales y accesos no autorizados, es una práctica de seguridad fundamental restringir el acceso a la consola de IBM Cloud y a las interfaces de API únicamente a direcciones IP o rangos de red de confianza (como la VPN corporativa, oficinas centrales o gateways de seguridad).

Si el atributo `allowed_ip_addresses` no se configura, IBM Cloud permite por defecto el acceso desde cualquier dirección IP pública (0.0.0.0/0). Habilitar estas restricciones reduce drásticamente la superficie de ataque para amenazas externas, ya que incluso si un atacante obtiene credenciales válidas, el sistema denegará la conexión si no se origina desde un origen autorizado.

## Lógica de la Regla

La política realiza las siguientes validaciones:
1.  Identifica el recurso único `ibm_iam_account_settings` en el proyecto.
2.  **Validación de Presencia:** Verifica si el atributo `allowed_ip_addresses` ha sido definido.
3.  **Validación de Integridad:** Verifica que la lista proporcionada no sea una lista vacía `[]`.
4.  Genera una alerta informativa si falta la configuración, instando al auditor a definir el perímetro de red de la cuenta.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Acceso Irrestricto (Sin Atributo)

* **Descripción:** El recurso no define ninguna restricción de red. El acceso a la cuenta está abierto a cualquier punto de internet.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_iam_account_settings" "default" {
      mfa = "TOTP"
      session_expiration_in_seconds = 3600
      # Falta el atributo 'allowed_ip_addresses'
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_iam_account_settings`.

---

### Caso 2: Lista de IPs Vacía

* **Descripción:** Se define el atributo pero no se incluyen direcciones IP de confianza.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_iam_account_settings" "empty_list" {
      allowed_ip_addresses = [] # <-- Alerta INFO
    }
    ```
* **Ubicación de la Alerta:** Atributo `allowed_ip_addresses`.

## Recurso Involucrado

* `ibm_iam_account_settings`

## Solución

Define explícitamente la lista de direcciones IP o subredes (en formato CIDR) que deben tener permiso de acceso a la cuenta.

```terraform
resource "ibm_iam_account_settings" "secure_account" {
  mfa                           = "TOTP"
  session_expiration_in_seconds = 86400
  
  # Restringir acceso solo a la VPN corporativa y oficina central
  allowed_ip_addresses = [
    "203.0.113.10",    # IP Estática Oficina
    "192.0.2.0/24"     # Rango VPN Corporativa
  ]
}