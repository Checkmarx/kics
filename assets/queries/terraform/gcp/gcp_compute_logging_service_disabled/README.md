# Regla KICS: GCP Compute Logging Service Disabled

## Descripción General

Esta regla de **Observabilidad** verifica que las instancias de **Google Compute Engine** (`google_compute_instance`) tengan habilitado el envío de registros al servicio de **Cloud Logging** mediante el metadato `google-logging-enabled`.

La visibilidad es un componente crítico de la seguridad. El agente de Google Cloud (Ops Agent) utiliza este flag para determinar si debe transmitir logs del sistema operativo y de aplicaciones a la consola centralizada de Google Cloud. Sin estos registros, la detección de intrusiones, el análisis forense y la resolución de errores operativos se vuelven tareas inviables.

## Lógica de la Regla

La política audita el recurso evaluando tres estados posibles de fallo para maximizar la precisión del reporte:
1.  **Bloque Ausente:** Si falta todo el bloque `metadata`.
2.  **Clave Ausente:** Si el bloque `metadata` existe pero no define la clave requerida.
3.  **Valor Incorrecto:** Si la clave existe pero se ha establecido explícitamente como `"false"`.

## Casos de Fallo Detectados

---

### Caso 1: Configuración de Metadatos Ausente
* **Descripción:** La instancia no define ningún metadato, omitiendo por tanto el servicio de logging.
* **Ubicación de la Alerta:** Nivel de recurso `google_compute_instance`.

### Caso 2: Flag de Logging Faltante
* **Descripción:** Se usan metadatos pero se omite específicamente `google-logging-enabled`.
* **Ubicación de la Alerta:** Atributo `metadata`.

### Caso 3: Logging Deshabilitado
* **Descripción:** Se ha configurado el valor `"false"`, bloqueando activamente la ingesta de logs.
* **Ubicación de la Alerta:** Atributo `google-logging-enabled`.

## Recurso Involucrado

* `google_compute_instance`

## Solución

Asegúrese de establecer el metadato en `"true"` para habilitar el servicio.

```terraform
resource "google_compute_instance" "secure_vm" {
  name         = "prod-server"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  metadata = {
    "google-logging-enabled" = "true"
  }
}