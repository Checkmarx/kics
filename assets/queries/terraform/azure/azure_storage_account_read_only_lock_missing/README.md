# Regla KICS: Storage Account ReadOnly Lock Missing

## Descripción General

Esta regla de KICS verifica que las cuentas de almacenamiento de Azure (`azurerm_storage_account`) tengan aplicado un **bloqueo de recursos** (`azurerm_management_lock`) configurado específicamente en el nivel **`ReadOnly`**.

Los bloqueos de Azure Resource Manager (ARM) proporcionan una capa de seguridad adicional que trasciende los permisos de RBAC. Aplicar un bloqueo de tipo `ReadOnly` a una cuenta de almacenamiento garantiza que la configuración del recurso (como las reglas de firewall, los niveles de acceso o la configuración de replicación) no pueda ser modificada ni el recurso eliminado accidentalmente, incluso por administradores. Es una práctica esencial para activos de datos críticos en entornos de producción.

## Lógica de la Regla

La política realiza un análisis cruzado entre los recursos de la cuenta de almacenamiento y los bloqueos definidos:
1.  **Identificación:** Localiza todas las instancias de `azurerm_storage_account`.
2.  **Vinculación:** Busca recursos `azurerm_management_lock` cuyo atributo `scope` referencie al ID del Storage Account.
3.  **Validación de Nivel:** Verifica que el atributo `lock_level` sea estrictamente `"ReadOnly"`.
4.  **Generación de Hallazgo:** Si el recurso no tiene ningún bloqueo o si los bloqueos existentes tienen un nivel inferior (como `CanNotDelete`), se genera una alerta.

## Casos de Fallo Detectados

### Caso 1: Storage Account sin Bloqueo

* **Descripción:** La cuenta de almacenamiento se ha desplegado sin ninguna restricción de gestión, permitiendo modificaciones accidentales.
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_storage_account`.

---

### Caso 2: Bloqueo con Nivel Incorrecto

* **Descripción:** Existe un bloqueo asociado al recurso, pero su nivel es `"CanNotDelete"`, lo cual permite modificaciones en la configuración que la regla busca restringir mediante `"ReadOnly"`.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_management_lock" "fail_lock" {
      name       = "prevent-deletion"
      scope      = azurerm_storage_account.example.id
      lock_level = "CanNotDelete" # <-- FALLO: Se requiere 'ReadOnly'
    }
    ```
* **Ubicación de la Alerta:** Atributo `lock_level` del recurso de bloqueo.

## Recursos Involucrados

* `azurerm_storage_account`
* `azurerm_management_lock`

## Solución

Añada un recurso `azurerm_management_lock` apuntando al ID de la cuenta de almacenamiento con el nivel `ReadOnly`.

```terraform
resource "azurerm_storage_account" "secure_sa" {
  name                     = "storage-prod-critical"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# SOLUCIÓN: Aplicar bloqueo ReadOnly
resource "azurerm_management_lock" "sa_readonly_lock" {
  name       = "critical-storage-lock"
  scope      = azurerm_storage_account.secure_sa.id
  lock_level = "ReadOnly"
  notes      = "Bloqueo de seguridad para cumplimiento de política de gobernanza"
}