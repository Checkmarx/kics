# Regla KICS: Cloud SQL PostgreSQL log_error_verbosity is Verbose

## Descripción General

Esta regla verifica la configuración del flag de base de datos `log_error_verbosity` en instancias de **Google Cloud SQL (PostgreSQL)**.

Este parámetro controla la cantidad de detalles que se escriben en el registro de errores del servidor. El nivel `verbose` incluye información interna como código fuente y números de línea, lo cual no es recomendado para entornos de producción por motivos de seguridad y rendimiento.

## Lógica de la Regla

La política inspecciona el recurso `google_sql_database_instance`:
1.  Verifica si la versión de la base de datos contiene "POSTGRES".
2.  Normaliza el bloque `settings.database_flags` para procesar correctamente tanto configuraciones con un único flag como con múltiples.
3.  Si encuentra un flag llamado `log_error_verbosity` con el valor `verbose`, genera una alerta.

## Casos de Fallo Detectados

### Caso 1: Verbosity Insegura

* **Descripción:** El flag está explícitamente configurado como `verbose`.
* **Ubicación de la Alerta:** Bloque `database_flags`.

## Recurso Involucrado

* `google_sql_database_instance`

## Solución

Establece el valor en `default`, `terse` o elimina el flag.

```terraform
resource "google_sql_database_instance" "secure" {
  database_version = "POSTGRES_14"
  settings {
    database_flags {
      name  = "log_error_verbosity"
      value = "default"
    }
  }
}