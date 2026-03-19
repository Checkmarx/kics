# Regla KICS: Google API Key API Targets Missing

## Descripción General

Esta regla de severidad **MEDIA** audita la configuración de las **Google API Keys** (`google_apikeys_key`) para asegurar que el acceso esté limitado exclusivamente a los servicios necesarios.

Cuando se genera una API Key en Google Cloud, por defecto tiene capacidad para invocar **cualquier API habilitada** en el proyecto. Esto representa un riesgo significativo de seguridad y costos; si una clave se ve comprometida (por ejemplo, al ser expuesta accidentalmente en el código fuente de una aplicación móvil o web), un atacante podría utilizarla para consumir servicios sensibles o de alto coste (como la API de Google Maps o modelos de IA) que no forman parte del propósito original de la aplicación. 

La mejor práctica de seguridad consiste en aplicar restricciones de "API Targets" para que la clave solo funcione con los servicios específicos para los que fue creada.

## Lógica de la Regla

La política evalúa dos escenarios de fallo en el código Terraform:
1.  **Ausencia de Restricciones:** El recurso no define ningún bloque `restrictions`, dejando la clave totalmente desprotegida.
2.  **Falta de Alcance de API:** El recurso define restricciones (como IPs o referrers), pero omite el bloque `api_targets`, permitiendo que esos orígenes autorizados consuman cualquier API del proyecto.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Restricciones Ausentes
* **Descripción:** La clave de API se define sin ningún tipo de control perimetral o de servicio.
* **Ubicación de la Alerta:** Bloque del recurso `google_apikeys_key`.

### Caso 2: API Targets no Definidos
* **Descripción:** Se aplican restricciones de cliente, pero se mantiene el acceso ilimitado a todos los servicios de Google habilitados en el proyecto.
* **Ubicación de la Alerta:** Atributo `restrictions`.

## Recurso Involucrado

* `google_apikeys_key`

## Solución

Añada el bloque `api_targets` dentro de la sección `restrictions` especificando los servicios necesarios.

```terraform
resource "google_apikeys_key" "secure_key" {
  name = "production-maps-key"

  restrictions {
    # Restricción de origen (ejemplo para navegador)
    browser_key_restrictions {
      allowed_referrers = ["[https://app.tu-empresa.com/](https://app.tu-empresa.com/)*"]
    }

    # Restricción de servicios (Solución)
    api_targets {
      service = "maps-backend.googleapis.com"
    }
    api_targets {
      service = "places-backend.googleapis.com"
    }
  }
}