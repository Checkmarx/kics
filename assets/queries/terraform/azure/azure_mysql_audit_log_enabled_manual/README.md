# Regla KICS: MySQL Audit Log Enabled (Manual)

## Descripción General

Esta regla de KICS actúa como un control manual para asegurar que el parámetro de servidor `audit_log_enabled` esté configurado en `ON` en las instancias de **Azure Database for MySQL**.

Los registros de auditoría son fundamentales para la observabilidad y la seguridad de la base de datos. Permiten rastrear eventos específicos, como intentos de conexión, ejecución de consultas DDL y cambios en privilegios de usuario. Debido a que en Azure MySQL estos parámetros pueden gestionarse de forma externa al recurso del servidor (ya sea por el portal o mediante recursos de configuración independientes), se requiere una validación manual para confirmar el cumplimiento.

## Lógica de la Regla

Dado que la configuración de auditoría no reside obligatoriamente dentro del bloque principal del servidor MySQL en Terraform, el análisis estático se centra en:
1.  **Identificación de Recursos:** La regla localiza todos los recursos de tipo `azurerm_mssql_server` y `azurerm_mysql_flexible_server`.
2.  **Recordatorio de Auditoría:** Genera un hallazgo de severidad informativa para alertar al administrador de la necesidad de verificar el estado del parámetro `audit_log_enabled`.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Verificación Manual Requerida

* **Descripción:** Se detecta la presencia de un servidor MySQL. Dado que el estado de la auditoría no siempre es verificable estáticamente desde el recurso del servidor, se solicita revisión manual.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_mssql_server" "example_insecure" {
      name                = "mysql-server-audit-check"
      resource_group_name = azurerm_resource_group.example.name
      location            = azurerm_resource_group.example.location
      # El estado de audit_log_enabled no es visible aquí.
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso del servidor MySQL detectado.

## Recurso Involucrado

* `azurerm_mssql_server`
* `azurerm_mysql_flexible_server`

## Solución

Existen dos métodos para asegurar que la auditoría esté habilitada:

### Opción A: Verificación Manual (Portal de Azure)
1. Navegue a su servidor MySQL en el Portal de Azure.
2. Acceda a la sección **Parámetros del servidor**.
3. Busque el parámetro `audit_log_enabled` y confirme que su valor sea `ON`.

### Opción B: Configuración como Código (Recomendado)
Utilice el recurso `azurerm_mysql_configuration` (para servidores Single Server) o `azurerm_mysql_flexible_server_configuration` (para Flexible Server) para forzar el parámetro:

```terraform
# Ejemplo para MySQL Single Server
resource "azurerm_mysql_configuration" "audit_log" {
  name                = "audit_log_enabled"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mssql_server.example.name
  value               = "ON"
}