# Regla KICS: Key Vault Key Rotation Disabled

## Descripción General

Esta regla de KICS verifica que las claves criptográficas almacenadas en Azure Key Vault (`azurerm_key_vault_key`) tengan configurada una política de rotación automática.

La rotación automática de claves es una práctica de seguridad esencial que limita la cantidad de datos cifrados con una sola versión de clave y reduce significativamente el impacto en caso de que una clave se vea comprometida. Configurar una política de rotación asegura que las claves se renueven de forma proactiva sin intervención manual, garantizando la continuidad operativa y el cumplimiento de estándares de seguridad como PCI-DSS o HIPAA.

## Lógica de la Regla

La política analiza el recurso `azurerm_key_vault_key` realizando los siguientes pasos:
1.  **Identificación de Claves:** Selecciona todos los recursos de tipo `azurerm_key_vault_key`.
2.  **Verificación de Política:** Comprueba la existencia del bloque de configuración `rotation_policy`.
3.  **Generación de Alerta:** Si el bloque está ausente, se considera que la clave no tiene una estrategia de rotación definida y se genera un hallazgo.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Clave sin política de rotación

* **Descripción:** Se define una clave criptográfica en Key Vault pero se omite el bloque `rotation_policy`, dejando la responsabilidad de la rotación a procesos manuales o permitiendo que la clave permanezca indefinidamente.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_key_vault_key" "fail_key" {
      name         = "example-key"
      key_vault_id = azurerm_key_vault.example.id
      key_type     = "RSA"
      key_size     = 2048
      key_opts     = ["decrypt", "encrypt", "sign", "verify"]
      
      # El recurso carece de la configuración rotation_policy
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_key_vault_key`.

## Recurso Involucrado

* `azurerm_key_vault_key`

## Solución

Para solucionar este riesgo, añada el bloque `rotation_policy` definiendo el tiempo de expiración y las reglas de rotación automática deseadas.

```terraform
resource "azurerm_key_vault_key" "secure_key" {
  name         = "example-key"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "verify"]

  # SOLUCIÓN: Definir política de rotación automática
  rotation_policy {
    expire_after         = "P90D"
    notify_before_expiry = "P29D"

    automatic {
      time_before_expiry = "P30D"
    }
  }
}