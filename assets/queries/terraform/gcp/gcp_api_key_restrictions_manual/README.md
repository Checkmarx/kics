# Regla KICS: Google API Key Restrictions (Manual)

## Descripción General

Esta regla informativa (INFO) audita la seguridad perimetral de las **Google API Keys** (`google_apikeys_key`).

A diferencia de las identidades de IAM, las API Keys no se autentican mediante un usuario, sino que se validan por su simple posesión. Por ello, es imperativo restringir su uso a direcciones IP, dominios web o aplicaciones móviles específicas. 

Esta regla garantiza que se aplique el principio de defensa en profundidad. Dado que una herramienta de análisis estático no puede determinar si una dirección IP o un dominio configurado es legítimo o excesivamente permisivo, la regla alerta tanto ante la ausencia de restricciones como ante su presencia, forzando una revisión manual de la lista de permitidos.

## Lógica de la Regla

La política evalúa el recurso en dos etapas:
1.  **Validación de Presencia:** Si falta el bloque `restrictions`, la clave se marca como vulnerable (acceso público).
2.  **Validación Manual:** Si el bloque `restrictions` existe, se genera una alerta informativa para que el auditor confirme que los valores (IPs, referrers, etc.) coinciden con los activos corporativos autorizados.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Sin Restricciones (Vulnerable)
* **Descripción:** La clave de API carece de restricciones de cliente, permitiendo que cualquier persona con la clave pueda realizar llamadas desde cualquier lugar de Internet.
* **Ubicación de la Alerta:** Bloque del recurso `google_apikeys_key`.

### Caso 2: Revisión de Restricciones (Manual Check)
* **Descripción:** La clave tiene restricciones configuradas. El auditor debe verificar que los valores definidos no sean genéricos o incorrectos.
* **Ubicación de la Alerta:** Atributo `restrictions`.

## Recurso Involucrado

* `google_apikeys_key`

## Solución

Implemente siempre el bloque `restrictions` utilizando el tipo de restricción que mejor se adapte al uso de la clave (Browser, Server, Android o iOS).

```terraform
resource "google_apikeys_key" "secure_api_key" {
  name = "frontend-maps-key"

  restrictions {
    # Ejemplo: Clave restringida a un dominio específico
    browser_key_restrictions {
      allowed_referrers = ["[https://app.example.com/](https://app.example.com/)*"]
    }

    # Recomendado: Combinar con restricción de API (API Targets)
    api_targets {
      service = "maps-backend.googleapis.com"
    }
  }
}