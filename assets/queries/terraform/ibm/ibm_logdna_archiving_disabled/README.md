# Regla KICS: Archivado Habilitado para IBM LogDNA

## Descripción General

Esta regla de KICS para Terraform asegura que cada instancia de **IBM LogDNA** (`ibm_logdna_instance`) tenga el archivado de eventos configurado mediante el recurso `ibm_logdna_archive`.

La retención de logs a largo plazo es una exigencia crítica en marcos de cumplimiento como **PCI DSS**, **SOC 2**, o **HIPAA**. El archivado permite mover los registros de la capa de búsqueda activa a una capa de almacenamiento de bajo costo (IBM Cloud Object Storage), garantizando que los datos estén disponibles para auditorías o investigaciones forenses meses o años después de su generación, incluso si la instancia operativa de Log Analysis ha purgado los datos de su caché de búsqueda.

## Lógica de la Regla

La política realiza un escaneo de correlación cruzada en el proyecto de Terraform. Identifica cualquier recurso `ibm_logdna_instance` que no sea referenciado en el atributo `instance_id` de ningún recurso `ibm_logdna_archive`. El fallo se dispara ante la **omisión completa** del recurso de archivado, lo que implica un riesgo de pérdida definitiva de datos tras el periodo de retención del plan.

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Recurso `ibm_logdna_archive` Ausente

* **Descripción:** Se provisiona una instancia de logs para gestionar la actividad de la plataforma o aplicaciones, pero no se define un destino de persistencia para el archivado.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_logdna_instance" "my_logs" {
      name = "prod-logs"
      plan = "7-day"
      target_resource_instance_id = ibm_resource_instance.logdna_inst.id
    }

    # ERROR: Falta el recurso ibm_logdna_archive que apunte a 'my_logs'
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_logdna_instance` huérfano de archivado.

## Recursos Involucrados

* `ibm_logdna_instance`
* `ibm_logdna_archive`

## Solución

Asegúrese de vincular cada instancia de LogDNA con un recurso `ibm_logdna_archive` que apunte a un bucket de IBM Cloud Object Storage.

```terraform
resource "ibm_logdna_archive" "archive_setup" {
  instance_id = ibm_logdna_instance.my_logs.id

  cos {
    api_key      = var.ibmcloud_api_key
    bucket       = "my-archiving-bucket"
    endpoint     = "s3.private.us-south.cloud-object-storage.appdomain.cloud"
    instance_crn = ibm_resource_instance.cos_inst.id
  }
}