# Regla KICS: Storage Immutability Policy Not Locked

## Descripción General

Esta regla verifica que las políticas de inmutabilidad (`azurerm_storage_container_immutability_policy`) aplicadas a los contenedores de Azure Storage estén configuradas en estado **Bloqueado** (`locked = true`).

Las políticas de inmutabilidad permiten que los datos se almacenen en un formato **WORM** (Write Once, Read Many). En el contexto de control de acceso y protección de datos, existen dos estados críticos:
* **Unlocked (Mutable):** La política protege los datos contra borrado o modificación, pero la política en sí puede ser eliminada o modificada por usuarios con altos privilegios. Es un estado transitorio y no garantiza la inalterabilidad a largo plazo.
* **Locked (Inmutable):** Una vez bloqueada, la política se vuelve irreversible; no puede ser eliminada y el periodo de retención solo puede aumentarse. Este estado es un control de integridad estricto que garantiza que ni siquiera un administrador pueda eliminar los datos antes de tiempo.

## Lógica de la Regla

La regla audita los recursos `azurerm_storage_container_immutability_policy` evaluando dos condiciones de control:
1.  **Omisión del Atributo:** Si no se define el atributo `locked`, Azure asume por defecto el estado "Unlocked", permitiendo que la protección sea removida.
2.  **Valor Incorrecto:** Si el atributo `locked` se establece explícitamente en `false`.

## Casos de Fallo Detectados

### Caso 1: Atributo de Bloqueo Ausente

* **Descripción:** Se define una política de retención pero no se especifica si debe estar bloqueada. Por defecto, Azure la crea en estado "Unlocked".
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_storage_container_immutability_policy" "fail_missing" {
      storage_container_resource_manager_id = azurerm_storage_container.example.id
      retention_period_in_days              = 365
      # Falta locked = true
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso raíz `azurerm_storage_container_immutability_policy`.

---

### Caso 2: Política Mutable (Unlocked)

* **Descripción:** El atributo `locked` se establece explícitamente en `false`, lo que permite que la política de inmutabilidad sea eliminable por usuarios autorizados.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_storage_container_immutability_policy" "fail_explicit" {
      storage_container_resource_manager_id = azurerm_storage_container.example.id
      retention_period_in_days              = 730
      locked                                = false # <-- PROBLEMA DETECTADO
    }
    ```
* **Ubicación de la Alerta:** Atributo `locked`.

## Recurso Involucrado

* `azurerm_storage_container_immutability_policy`

## Solución

Establezca el atributo `locked` en `true` para asegurar que el control de integridad de los datos sea permanente y cumpla con los requisitos WORM.

> [!WARNING]
> **Advertencia Crítica:** Una vez que una política se bloquea en Azure, **no puede eliminarse**. Solo podrá borrar el contenedor una vez que el periodo de retención de todos los objetos haya expirado. Valide cuidadosamente los días de retención antes de aplicar este cambio en producción.

```terraform
resource "azurerm_storage_container_immutability_policy" "secure_policy" {
  storage_container_resource_manager_id = azurerm_storage_container.example.id
  retention_period_in_days              = 365
  
  # SOLUCIÓN: Bloqueo de política habilitado para integridad WORM
  locked                                = true
}