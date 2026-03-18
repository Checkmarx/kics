# Regla KICS: GCP HTTP(S) Load Balancer Logging Disabled

## Descripción General

Esta regla de severidad **MEDIA** verifica que el registro de acceso (Logging) esté habilitado en los recursos `google_compute_backend_service` de Google Cloud.

Los Backend Services gestionan el tráfico que el balanceador de carga HTTP(S) distribuye hacia los grupos de instancias o buckets. Habilitar los logs de Cloud Armor y del balanceador permite capturar metadatos críticos de cada transacción HTTP: dirección IP de origen, protocolos, latencias de respuesta, y códigos de estado (2xx, 4xx, 5xx). Sin estos registros, la capacidad de respuesta ante incidentes de seguridad (como ataques DoS o inyecciones) y la depuración de errores de infraestructura se ven seriamente limitadas.

## Lógica de la Regla

La política audita el recurso `google_compute_backend_service` bajo dos criterios:
1.  **Omisión:** Detecta si el bloque `log_config` no ha sido definido.
2.  **Desactivación:** Detecta si el atributo `enable` dentro de `log_config` tiene el valor booleano `false`.

## Casos de Fallo Detectados

---

### Caso 1: Configuración de Logging Ausente
* **Descripción:** El servicio de backend se crea sin parámetros de registro, lo que deshabilita la telemetría de tráfico por defecto.
* **Ubicación de la Alerta:** Nivel de recurso `google_compute_backend_service`.

### Caso 2: Logging Deshabilitado Explícitamente
* **Descripción:** Se define el bloque de configuración pero se apaga el servicio de logs.
* **Ubicación de la Alerta:** Atributo `enable` dentro de `log_config`.

## Recurso Involucrado

* `google_compute_backend_service`

## Solución

Añada el bloque `log_config` con el parámetro `enable = true`. Se recomienda un `sample_rate` de `1.0` para producción.

```terraform
resource "google_compute_backend_service" "compliant_service" {
  name        = "web-backend-service"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 10

  # Solución técnica
  log_config {
    enable      = true
    sample_rate = 1.0
  }
}