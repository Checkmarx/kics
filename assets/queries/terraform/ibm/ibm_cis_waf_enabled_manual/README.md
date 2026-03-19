# Regla KICS: IBM CIS WAF Not Enabled (Manual)

## Descripción General

Esta regla informativa (INFO) audita la configuración de **IBM Cloud Internet Services (CIS)** para asegurar que la protección de capa de aplicación esté activa.

El recurso `ibm_cis_domain_settings` permite gestionar las capacidades de seguridad a nivel de dominio. El atributo `waf` funciona como el interruptor principal del Cortafuegos de Aplicaciones Web. Para mitigar riesgos asociados a vulnerabilidades web comunes y cumplir con estándares de seguridad industrial (como PCI-DSS), este atributo debe estar establecido explícitamente en `on`.

**Nota importante:** Activar `waf = "on"` habilita el motor de inspección, pero la efectividad real depende de la configuración posterior de los paquetes de reglas (OWASP, reglas específicas de CIS, etc.) mediante el recurso `ibm_cis_waf_package`. Esta alerta sirve como punto de partida para verificar que la base de la protección está presente.

## Lógica de la Regla

1.  Identifica todos los recursos de tipo `ibm_cis_domain_settings`.
2.  Verifica la presencia y el valor del atributo `waf`.
3.  Genera una alerta informativa si:
    * El atributo `waf` está configurado con un valor distinto a `"on"` (por ejemplo, `"off"`).
    * El atributo `waf` no ha sido definido en el recurso.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: WAF Deshabilitado Explícitamente

* **Descripción:** El recurso define el WAF como `"off"`, desactivando la inspección de tráfico de capa 7.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_cis_domain_settings" "insecure" {
      cis_id    = ibm_cis.instance.id
      domain_id = ibm_cis_domain.example.id
      waf       = "off" # <-- Alerta INFO
    }
    ```
* **Ubicación de la Alerta:** Atributo `waf`.

---

### Caso 2: Configuración de WAF Ausente

* **Descripción:** No se especifica el estado del WAF, lo que puede llevar a estados de seguridad inconsistentes dependiendo del plan de CIS contratado.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_cis_domain_settings" "default_settings" {
      cis_id    = ibm_cis.instance.id
      domain_id = ibm_cis_domain.example.id
      # El atributo 'waf' no está definido
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_cis_domain_settings`.

## Recurso Involucrado

* `ibm_cis_domain_settings`

## Solución

Habilita el motor del WAF estableciendo el atributo a `"on"` dentro de la configuración del dominio.

```terraform
resource "ibm_cis_domain_settings" "secure_settings" {
  cis_id    = ibm_cis.instance.id
  domain_id = ibm_cis_domain.example.id
  
  # Habilitar WAF Global
  waf       = "on"
  
  # Recomendaciones adicionales de seguridad
  ssl             = "strict"
  min_tls_version = "1.2"
}