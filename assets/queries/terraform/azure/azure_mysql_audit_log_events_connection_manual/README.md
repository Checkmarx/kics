# Regla KICS: MySQL Audit Log Events Connection (Manual)

## Descripción General

Esta regla de KICS actúa como un control manual para verificar que el parámetro de servidor `audit_log_events` incluya el valor `CONNECTION` en los servidores de **Azure Database for MySQL**.

El registro de los eventos de tipo `CONNECTION` es una pieza fundamental de la estrategia de seguridad y cumplimiento. Permite a los administradores y auditores rastrear quién accede a la base de datos, detectar ataques de fuerza bruta (intentos fallidos) y auditar sesiones sospechosas. Sin esta configuración, se pierde visibilidad sobre el acceso inicial a los recursos de datos, dificultando la respuesta ante incidentes.

## Lógica de la Regla

Debido a que el análisis estático no siempre puede garantizar la verificación de una cadena de texto dentro de un recurso de configuración independiente (`azurerm_mysql_configuration`), esta regla aplica un enfoque preventivo:
1.  **Identificación de Recursos:** Detecta todas las instancias de `azurerm_mssql_server` y `azurerm_mysql_flexible_server`.
2.  **Recordatorio de Seguridad:** Genera una alerta informativa para que el auditor verifique específicamente que el evento de conexión esté siendo capturado.

## Caso de Fallo Detectado

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Verificación Manual Requerida

* **Descripción:** Se detecta un servidor MySQL aprovisionado. KICS emite una alerta para asegurar que los tipos de eventos auditados incluyan las conexiones, ya que esta configuración puede estar delegada a otros recursos o al portal.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_mssql_server" "example_audit_check" {
      name                = "mysql-server-connection-check"
      resource_group_name = azurerm_resource_group.example.name
      location            = azurerm_resource_group.example.location
      # El contenido de audit_log_events no es verificable aquí.
    }
    ```
* **Ubicación de la Alerta:** Sobre el recurso del servidor MySQL detectado.

## Recurso Involucrado

* `azurerm_mssql_server`
* `azurerm_mysql_flexible_server`

## Solución

### Opción A: Verificación Manual (Portal de Azure)
1. Navegue al servidor MySQL en el Portal de Azure.
2. Vaya a la sección **Parámetros del servidor**.
3. Localice el parámetro `audit_log_events`.
4. Asegúrese de que entre los valores seleccionados se incluya `CONNECTION`.

### Opción B: Configuración mediante Terraform
Asegúrese de incluir explícitamente el valor en el recurso de configuración:

```terraform
resource "azurerm_mysql_configuration" "audit_events" {
  name                = "audit_log_events"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mssql_server.example.name
  
  # SOLUCIÓN: Incluir CONNECTION en la lista de eventos
  value               = "CONNECTION,QUERY,DDL" 
}