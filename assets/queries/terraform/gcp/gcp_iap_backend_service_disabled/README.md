# Regla KICS: IAP Disabled on Backend Service

## Descripción General

Esta regla verifica que **Identity-Aware Proxy (IAP)** esté habilitado en los recursos `google_compute_backend_service`.

IAP es un componente de seguridad Zero Trust que intercepta las solicitudes web enviadas a tu aplicación, autentica al usuario mediante su identidad de Google y solo permite el paso de la solicitud si el usuario está autorizado.

**Nota sobre Firewall (Manual):**
Habilitar IAP es solo el primer paso. Para cumplir completamente con la normativa de seguridad ("Permitir solo tráfico de Google"), debes configurar manualmente las reglas de firewall de tu VPC para permitir el tráfico **únicamente** desde los rangos de IP de los balanceadores de carga de Google (`130.211.0.0/22` y `35.191.0.0/16`) hacia tus instancias, bloqueando todo el tráfico directo desde Internet.

## Lógica de la Regla

La política audita el recurso `google_compute_backend_service`:
1.  Verifica si existe el bloque de configuración `iap`.
2.  Si el bloque no existe, se considera que el servicio no está protegido por identidad.
3.  Verifica que, si el bloque existe, se definan las credenciales necesarias (`oauth2_client_id` y `oauth2_client_secret`).

## Casos de Fallo Detectados

### Caso 1: IAP Deshabilitado

* **Descripción:** El servicio de backend se ha definido sin el bloque `iap`, lo que significa que el tráfico llega directamente (o a través del LB estándar) sin verificación de identidad previa por parte de IAP.
* **Ubicación de la Alerta:** Recurso `google_compute_backend_service`.

### Caso 2: Cliente ID de OAuth Ausente

* **Descripción:** El bloque `iap` está presente pero omite el `oauth2_client_id`, impidiendo la autenticación.
* **Ubicación de la Alerta:** Bloque `iap`.

### Caso 3: Cliente Secret de OAuth Ausente

* **Descripción:** El bloque `iap` está presente pero omite el `oauth2_client_secret`, impidiendo la autenticación.
* **Ubicación de la Alerta:** Bloque `iap`.

## Recurso Involucrado

* `google_compute_backend_service`

## Solución

Define el bloque `iap` dentro del servicio de backend e incluye las credenciales de OAuth necesarias.

```terraform
resource "google_compute_backend_service" "secure" {
  name          = "iap-backend-service"
  health_checks = [google_compute_health_check.default.id]

  iap {
    oauth2_client_id     = "abc-123.apps.googleusercontent.com"
    oauth2_client_secret = "secret-key"
  }
}