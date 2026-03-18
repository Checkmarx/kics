# Regla KICS: Cloud SQL PostgreSQL log_statement Improperly Set

## Descripción General

Esta regla verifica la configuración del flag `log_statement` en instancias de **Google Cloud SQL (PostgreSQL)**.

Este parámetro controla qué sentencias SQL se registran en los logs del servidor:
* **`none`:** No registra ninguna sentencia (Default).
* **`ddl`:** Registra sentencias de definición de datos (CREATE, ALTER, DROP). Recomendado por CIS Benchmark como línea base.
* **`mod`:** Registra DDL y sentencias de modificación de datos (INSERT, UPDATE, DELETE).
* **`all`:** Registra todas las sentencias.

Para cumplir con normativas de auditoría y seguridad, se debe configurar al menos en `ddl` para rastrear cambios estructurales en la base de datos que podrían comprometer la integridad de la misma.

## Lógica de la Regla

La política evalúa el recurso `google_sql_database_instance` (PostgreSQL):
1.  **Flag Ausente:** Si `log_statement` no se encuentra dentro de la lista de flags configurados, falla (ya que el valor por defecto de PostgreSQL es insuficiente para auditoría).
2.  **Flag Incorrecto:** Si `log_statement` está presente pero su valor es explícitamente `none`, falla.

## Casos de Fallo Detectados

### Caso 1: Configuración Ausente
* **Descripción:** No se ha definido el flag, por lo que la base de datos no está auditando sentencias críticas.
* **Ubicación de la Alerta:** Bloque `database_flags`.

### Caso 2: Auditoría Deshabilitada Explícitamente
* **Descripción:** El flag está configurado con el valor `none`, desactivando el registro de sentencias.
* **Ubicación de la Alerta:** Bloque `database_flags`.

## Recurso Involucrado

* `google_sql_database_instance`

## Solución

Establezca el valor del flag `log_statement` en `ddl` (mínimo recomendado para auditoría), `mod` o `all`.

```terraform
resource "google_sql_database_instance" "secure" {
  name             = "secure-postgresql"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    database_flags {
      name  = "log_statement"
      value = "ddl"
    }
  }
}