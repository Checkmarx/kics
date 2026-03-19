# Regla KICS: Alertas Definidas para Vistas de IBM LogDNA

## Descripción General

Esta regla de severidad **BAJA** de KICS para Terraform asegura que cada vista personalizada de **IBM Log Analysis (LogDNA)** (`ibm_logdna_view`) tenga al menos una alerta (`ibm_logdna_alert`) configurada.

Las vistas personalizadas se diseñan para filtrar y aislar eventos críticos, como errores de sistema, intentos de acceso fallidos o picos de tráfico. Sin embargo, la monitorización solo es efectiva si es proactiva. Si una vista existe pero carece de una alerta vinculada, el equipo de operaciones o seguridad depende de la revisión manual periódica de los logs, lo que aumenta drásticamente el tiempo de respuesta ante incidentes (MTTR).

## Lógica de la Regla

La política realiza una correlación cruzada dentro de los archivos de Terraform. Identifica cualquier recurso `ibm_logdna_view` cuyo nombre no sea referenciado en el atributo `view` de ningún recurso `ibm_logdna_alert`. La regla se activa ante la **omisión del recurso de alerta**, señalando que la vista no tiene un canal de notificación activo.

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso Único: Vista de LogDNA sin Alerta Asociada

* **Descripción:** Se define una vista específica para errores críticos o auditoría, pero no se inyecta un recurso de alerta para notificar a los responsables.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_logdna_view" "security_audit_view" {
      name  = "Security-Audit-Trail"
      query = "app:iam-service action:login-failed"
      # Error: No hay un recurso ibm_logdna_alert asociado a esta vista
    }
    ```
* **Ubicación de la Alerta:** Bloque del recurso `ibm_logdna_view` huérfano de notificación.

## Recursos Involucrados

* `ibm_logdna_view`
* `ibm_logdna_alert`

## Solución

Asocie un recurso `ibm_logdna_alert` a la vista utilizando el nombre de la misma en el parámetro `view`.

```terraform
resource "ibm_logdna_alert" "security_alert" {
  name = "IAM-Failure-Alert"
  view = ibm_logdna_view.security_audit_view.name

  notification_channel {
    email {
      recipients = ["security-ops@tu-empresa.com"]
    }
  }
}