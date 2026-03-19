# Regla KICS: IBM Cluster Missing VA Alerts (Automated)

## Descripción General

Esta regla de severidad **MEDIA** audita el despliegue de clústeres de Kubernetes (`ibm_container_cluster`) en IBM Cloud para asegurar que existan canales de comunicación activos para la gestión de vulnerabilidades.

El uso de orquestadores de contenedores implica el manejo constante de imágenes de software. IBM Cloud proporciona el **Vulnerability Advisor (VA)**, que escanea automáticamente estas imágenes en el registro. Sin embargo, en un flujo de trabajo de DevSecOps eficiente, el escaneo por sí solo no es suficiente; es imperativo que el sistema pueda notificar a los responsables cuando se detecten nuevas vulnerabilidades o cambios en el estado de seguridad de una imagen.

Si estás desplegando un clúster mediante Terraform, la práctica recomendada es incluir en el mismo código la configuración de las notificaciones (`ibm_container_va_notification`), ya sea mediante correo electrónico o webhooks, para garantizar una respuesta rápida ante posibles amenazas.

## Lógica de la Regla

1.  Identifica todos los recursos de tipo `ibm_container_cluster` en la configuración.
2.  Escanea el documento de Terraform en busca de *cualquier* instancia del recurso `ibm_container_va_notification`.
3.  Si se detecta la creación de un clúster pero no existe ninguna configuración de notificaciones de VA, genera una alerta apuntando al recurso del clúster.

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso 1: Clúster sin Alertas de Vulnerabilidad

* **Descripción:** Se define un clúster de Kubernetes en la infraestructura, pero se omite la configuración del canal de alertas (email/webhook) para el Vulnerability Advisor. Esto crea un punto ciego donde las imágenes vulnerables podrían pasar desapercibidas.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_container_cluster" "production_cluster" {
      name            = "prod-cluster"
      datacenter      = "dal10"
      machine_type    = "b3c.4x16"
      hardware        = "shared"
      public_vlan_id  = "123456"
      private_vlan_id = "654321"
      
      # No hay un recurso 'ibm_container_va_notification' asociado en el proyecto
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_container_cluster`.

## Recurso Involucrado

* `ibm_container_cluster`
* `ibm_container_va_notification`

## Solución

Para solucionar esta alerta, añade un recurso de notificación de VA que apunte al clúster o al grupo de recursos correspondiente.

```terraform
resource "ibm_container_va_notification" "vulnerability_alerts" {
  cluster_id = ibm_container_cluster.production_cluster.id
  email      = "security-ops@tu-empresa.com"
}