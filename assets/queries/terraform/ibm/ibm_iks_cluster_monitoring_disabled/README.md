# Regla KICS: Monitorización Habilitada para Clusters de IKS

## Descripción General

Esta regla de KICS para Terraform asegura que cada clúster de IBM Cloud Kubernetes Service (`ibm_container_cluster`) tenga una configuración de monitorización de **IBM Cloud Monitoring** (`ibm_ob_monitoring_config`) vinculada.

La monitorización de un clúster de Kubernetes es un requisito crítico para la operatividad y estabilidad. Permite obtener métricas en tiempo real sobre el uso de CPU, memoria, tráfico de red y latencia de los servicios. Sin esta visibilidad, los equipos de operaciones no pueden detectar cuellos de botella, prever la saturación de recursos mediante escalado automático, ni responder proactivamente a incidentes de salud en la infraestructura.

## Lógica de la Regla

La política implementa una lógica de correlación cruzada en el documento de Terraform. Identifica cualquier recurso `ibm_container_cluster` que no sea referenciado en el atributo `scope` de ningún recurso `ibm_ob_monitoring_config`. La vinculación se valida cuando el nombre o el CRN del clúster se incluye en el ámbito de la configuración de monitorización.

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Configuración de Monitorización Ausente para un Clúster

* **Descripción:** El clúster se aprovisiona sin los agentes o la vinculación necesaria para enviar métricas al servicio de monitorización centralizado de IBM Cloud.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_container_cluster" "cluster_unmonitored" {
      name            = "production-iks-cluster"
      datacenter      = "dal10"
      machine_type    = "b3c.4x16"
      hardware        = "shared"
      # No existe un recurso ibm_ob_monitoring_config apuntando a este clúster
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará directamente al bloque de código del recurso `ibm_container_cluster` huérfano de monitorización.

## Recursos Involucrados

* `ibm_container_cluster`
* `ibm_ob_monitoring_config`

## Solución

Para solucionar esta alerta, debe existir un recurso `ibm_ob_monitoring_config` que conecte el clúster con una instancia de monitorización (basada en Sysdig).

```terraform
resource "ibm_ob_monitoring_config" "monitoring_setup" {
  # Relación directa con el clúster
  scope    = ibm_container_cluster.my_cluster.crn
  instance = ibm_resource_instance.sysdig_instance.guid
}

resource "ibm_resource_instance" "sysdig_instance" {
  name     = "cluster-metrics-aggregator"
  service  = "sysdig-monitor"
  plan     = "graduated-tier"
  location = "us-south"
}