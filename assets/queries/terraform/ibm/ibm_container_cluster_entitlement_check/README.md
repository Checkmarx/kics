# Regla KICS: IBM Cluster Entitlement Key Missing (Automated)

## Descripción General

Esta regla informativa (INFO) audita el recurso `ibm_container_cluster` en IBM Cloud Kubernetes Service (IKS).

En IBM Cloud, la gestión de **Image Pull Secrets** (credenciales para descargar imágenes de contenedores) se puede automatizar en Terraform de varias formas. Una de las más directas y seguras para el software empresarial es el uso del argumento `entitlement`.

Cuando se define este argumento, el sistema crea automáticamente un secreto de Kubernetes dentro del clúster con las credenciales necesarias para autenticarse contra el **IBM Entitled Registry**. Esto asegura la integridad de la cadena de suministro al permitir el despliegue de **IBM Cloud Paks** y otro software licenciado sin la necesidad de crear, inyectar o gestionar manualmente objetos `Secret` de Kubernetes, reduciendo el riesgo de exposición de credenciales y fallos en el despliegue por secretos expirados.

## Lógica de la Regla

1.  Identifica recursos de tipo `ibm_container_cluster`.
2.  Verifica si el atributo `entitlement` está presente en la configuración.
3.  Si falta, genera una alerta informativa. 

**Nota técnica:** No todos los clústeres requieren software titulado (muchos corren aplicaciones propias). Sin embargo, en entornos corporativos de IBM, es una mejor práctica verificar si se ha habilitado esta automatización. Para registros privados que no sean el Entitled Registry, se recomienda usar el recurso `ibm_container_bind_service`.

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso 1: Clave de Titulación (Entitlement) Faltante

* **Descripción:** El clúster se provisiona sin credenciales automáticas para el registro de IBM. Esto requerirá que el administrador gestione los secretos de descarga de imágenes de forma manual.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_container_cluster" "example_no_entitlement" {
      name            = "my-app-cluster"
      datacenter      = "dal10"
      machine_type    = "b3c.4x16"
      hardware        = "shared"
      public_vlan_id  = "1234567"
      private_vlan_id = "7654321"
      
      # Falta el atributo 'entitlement'
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_container_cluster`.

## Recurso Involucrado

* `ibm_container_cluster`

## Solución

Si el clúster va a ejecutar software licenciado de IBM, añade tu clave de titulación al recurso del clúster.

```terraform
resource "ibm_container_cluster" "secure_cluster" {
  name            = "production-cluster"
  datacenter      = "dal10"
  machine_type    = "u3c.2x4"
  hardware        = "shared"
  public_vlan_id  = "123456"
  private_vlan_id = "654321"

  # Automatización del Image Pull Secret para IBM Entitled Registry
  entitlement     = "cloud_pak_entitlement_key_or_api_key" 
}