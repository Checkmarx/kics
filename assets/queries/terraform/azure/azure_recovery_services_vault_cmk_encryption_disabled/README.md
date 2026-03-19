# Regla KICS: Recovery Services Vault CMK Encryption Disabled

## Descripción General

Esta regla de KICS verifica que los almacenes de **Recovery Services Vault** (utilizados para Azure Backup y Azure Site Recovery) estén configurados para utilizar claves gestionadas por el cliente (**Customer-Managed Keys - CMK**) para el cifrado de datos en reposo.

Por defecto, los datos respaldados se cifran mediante claves gestionadas por la plataforma de Microsoft. Sin embargo, para cumplir con requisitos de cumplimiento normativo y garantizar la soberanía de los datos, las organizaciones deben utilizar sus propias claves almacenadas en Azure Key Vault. Esto permite un control total sobre la rotación de claves, las políticas de acceso y la capacidad de revocar el acceso a los datos de respaldo en caso de necesidad.

## Lógica de la Regla

La política analiza el recurso `azurerm_recovery_services_vault` validando la siguiente condición técnica:
1.  **Presencia del Bloque de Cifrado:** Se comprueba la existencia del bloque `encryption`. La ausencia de este bloque implica que el almacén utiliza el cifrado predeterminado gestionado por la plataforma, lo cual no cumple con los requisitos de CMK.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Uso de Claves de la Plataforma (Cifrado por Defecto)

* **Descripción:** Se define el Recovery Services Vault sin el bloque de configuración de cifrado por cliente, delegando la protección de los datos a las claves automáticas de Azure.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_recovery_services_vault" "fail_vault" {
      name                = "insecure-vault"
      location            = "West Europe"
      resource_group_name = "rg-production"
      sku                 = "Standard"
      
      # El recurso carece del bloque encryption {}
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_recovery_services_vault`.

## Recurso Involucrado

* `azurerm_recovery_services_vault`

## Solución

Para solucionar este hallazgo, debe habilitar una identidad gestionada en el Vault y configurar el bloque `encryption` proporcionando obligatoriamente el `key_id` de Azure Key Vault.

```terraform
resource "azurerm_recovery_services_vault" "secure_vault" {
  name                = "secure-recovery-vault"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"

  # 1. Habilitar identidad para acceso al Key Vault
  identity {
    type = "SystemAssigned"
  }

  # 2. Configurar el cifrado CMK (key_id es obligatorio en este bloque)
  encryption {
    key_id                       = azurerm_key_vault_key.example.id
    use_system_assigned_identity = true
  }
}