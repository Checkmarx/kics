# Regla KICS: Logging Habilitado para Clusters de IKS

## Descripción General

Esta regla de KICS para Terraform asegura que cada clúster de IBM Cloud Kubernetes Service (`ibm_container_cluster`) tenga una configuración de logging de IBM Cloud Log Analysis (`ibm_ob_logging_config`) correctamente asociada.

La agregación de logs de un clúster de Kubernetes es una práctica fundamental para la observabilidad y la seguridad. Permite a los equipos de desarrollo y operaciones centralizar los logs de los contenedores, los nodos y los componentes del sistema. Sin esta configuración, el análisis forense tras un incidente de seguridad o la resolución de errores en aplicaciones distribuidas se vuelve extremadamente compleja.

## Lógica de la Regla

La política implementa una lógica de correlación de recursos en todo el proyecto. Su función es identificar cualquier instancia de `ibm_container_cluster` que no esté referenciada en el atributo `scope` de ningún recurso `ibm_ob_logging_config`. La conexión se considera válida cuando el nombre o CRN del clúster aparece en el alcance (scope) de la configuración de observabilidad.

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Configuración de Logging Ausente para un Clúster

* **Descripción:** Esta regla detecta cualquier clúster de IKS que se esté aprovisionando sin su correspondiente pieza de telemetría para logs. 
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_container_cluster" "orphan_cluster" {
      name            = "my-production-cluster"
      datacenter      = "dal10"
      machine_type    = "b3c.4x16"
      hardware        = "shared"
      # No existe un recurso ibm_ob_logging_config que use este clúster como scope
    }
    ```
* **Ubicación de la Alerta:** La alerta señalará directamente al bloque de código del recurso `ibm_container_cluster` huérfano de configuración de logs.

## Recursos Involucrados

* `ibm_container_cluster`
* `ibm_ob_logging_config`

## Solución

Para solucionar los problemas detectados, asegúrese de que para cada clúster exista un recurso `ibm_ob_logging_config` que vincule el clúster con una instancia de Log Analysis.

```terraform
resource "ibm_ob_logging_config" "cluster_telemetry" {
  # Vincular con el clúster mediante su CRN o ID
  scope    = ibm_container_cluster.my_cluster.crn
  instance = ibm_resource_instance.log_analysis_inst.guid
}

resource "ibm_resource_instance" "log_analysis_inst" {
  name     = "log-aggregator"
  service  = "logdna"
  plan     = "7-day"
  location = "us-south"
}