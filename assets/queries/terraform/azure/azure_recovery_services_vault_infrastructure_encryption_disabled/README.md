# Regla KICS: Recovery Services Vault Infrastructure Encryption Disabled

## Descripción General

Esta regla de KICS verifica que el **Cifrado de Infraestructura** (`infrastructure_encryption_enabled`) esté habilitado en los almacenes de **Recovery Services Vault**.

El cifrado de infraestructura proporciona una capa adicional de protección mediante el uso de un segundo algoritmo de cifrado (**Double Encryption**). Mientras que todos los datos en Azure ya están cifrados en reposo, habilitar esta opción asegura que los datos se cifren dos veces utilizando dos algoritmos independientes. Esta configuración es fundamental para organizaciones con requisitos de cumplimiento altamente estrictos que buscan mitigar riesgos ante posibles vulnerabilidades en un único estándar criptográfico.

## Lógica de la Regla

La política analiza el recurso `azurerm_recovery_services_vault` validando dos aspectos técnicos:
1.  **Bloque de Cifrado:** Verifica la existencia del bloque `encryption`. Si no existe, se asume que no hay doble cifrado.
2.  **Cifrado de Infraestructura:** Verifica que el atributo `infrastructure_encryption_enabled` esté explícitamente establecido en `true`.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Bloque de Cifrado Ausente

* **Descripción:** El almacén no tiene definido el bloque `encryption`, por lo que utiliza únicamente el cifrado predeterminado de Azure sin capas adicionales.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_recovery_services_vault" "fail_missing" {
      name                = "insecure-vault"
      resource_group_name = "rg-prod"
      location            = "West Europe"
      sku                 = "Standard"
      # Falta bloque encryption {}
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_recovery_services_vault`.

---

### Caso 2: Cifrado de Infraestructura Deshabilitado

* **Descripción:** El bloque `encryption` existe pero el atributo `infrastructure_encryption_enabled` no está configurado o se encuentra en `false`.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_recovery_services_vault" "fail_disabled" {
      name = "vault-vulnerable"
      # ...
      encryption {
        key_id                            = azurerm_key_vault_key.example.id
        infrastructure_encryption_enabled = false
        use_system_assigned_identity      = true
      }
    }
    ```
* **Ubicación de la Alerta:** Atributo `infrastructure_encryption_enabled`.

## Recurso Involucrado

* `azurerm_recovery_services_vault`

## Solución

Para mitigar este riesgo, asegúrese de declarar el bloque `encryption` estableciendo `infrastructure_encryption_enabled` en `true`.

```terraform
resource "azurerm_recovery_services_vault" "secure_vault" {
  name                = "secure-recovery-vault"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Standard"

  identity {
    type = "SystemAssigned"
  }

  encryption {
    key_id                            = azurerm_key_vault_key.example.id
    infrastructure_encryption_enabled = true
    use_system_assigned_identity      = true
  }
}