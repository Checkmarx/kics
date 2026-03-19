# Regla KICS: IBM CIS DNS Record Not Proxied (Manual)

## Descripción General

Esta regla informativa (INFO) audita los registros DNS creados en **IBM Cloud Internet Services (CIS)** mediante el recurso `ibm_cis_dns_record`.

En la arquitectura de CIS, la **Protección DDoS** de capa 3/4 y capa 7, el WAF y la aceleración CDN solo se activan cuando el tráfico es enrutado a través de la red perimetral de CIS. Esto se configura estableciendo el atributo `proxied` en `true` (modo comúnmente conocido como "Orange Cloud").

Si `proxied` es `false` (o se omite), CIS actúa solo como un servidor DNS tradicional ("DNS Only" o "Grey Cloud"), resolviendo la IP del servidor de origen directamente hacia el cliente. Esto expone la IP real del servidor a internet, haciéndolo vulnerable a ataques directos de denegación de servicio (DDoS) y eludiendo cualquier regla de seguridad perimetral de CIS.

## Lógica de la Regla

1.  Identifica recursos de tipo `ibm_cis_dns_record`.
2.  Verifica el valor del atributo `proxied`.
3.  Si el valor es explícitamente `false` o si el atributo no ha sido definido (lo que resulta en un valor por defecto de `false`), genera una alerta informativa.

**Nota para el Auditor:** No todos los registros deben estar protegidos por proxy. Registros TXT, MX, o servicios que utilizan protocolos no soportados por el proxy de CIS (como el tráfico no HTTP en ciertos puertos) deben permanecer en `false`. La alerta sirve para verificar manualmente que los registros `A`, `AAAA` y `CNAME` de aplicaciones web críticas estén bajo el escudo de protección.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Proxy Desactivado Explícitamente

* **Descripción:** Se ha configurado `proxied = false`. El tráfico fluye directamente al servidor de origen sin pasar por los filtros de CIS.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_cis_dns_record" "dns_only" {
      cis_id  = ibm_cis.instance.id
      domain_id = ibm_cis_domain.example.id
      name    = "web"
      type    = "A"
      content = "1.2.3.4"
      proxied = false # <-- Alerta INFO
    }
    ```
* **Ubicación de la Alerta:** Atributo `proxied`.

---

### Caso 2: Proxy No Definido (DNS Only por Defecto)

* **Descripción:** Falta el atributo en la definición. Por defecto, CIS no activa el proxy, dejando el registro sin protección DDoS.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_cis_dns_record" "default_record" {
      cis_id  = ibm_cis.instance.id
      domain_id = ibm_cis_domain.example.id
      name    = "app"
      type    = "A"
      content = "1.2.3.4"
      # Falta el atributo 'proxied'
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_cis_dns_record`.

## Recurso Involucrado

* `ibm_cis_dns_record`

## Solución

Habilita el proxy para activar la protección DDoS y las características de aceleración de CIS.

```terraform
resource "ibm_cis_dns_record" "secure_record" {
  cis_id    = var.cis_instance_id
  domain_id = var.domain_id
  name      = "www"
  type      = "A"
  content   = "1.2.3.4"
  
  # Habilitar protección DDoS, WAF y CDN
  proxied = true
}