# Regla KICS: GKE Workload Identity & Dedicated SA (Manual)

## Descripción General

Esta regla informativa (**INFO**) de **Access Control** audita la configuración de identidad para las cargas de trabajo que se ejecutan en **Google Kubernetes Engine (GKE)**.

La mejor práctica de seguridad para que las aplicaciones de GKE accedan a los servicios de Google Cloud (como Cloud Storage o BigQuery) es utilizar **Workload Identity**. Esta funcionalidad elimina la necesidad de descargar y gestionar claves JSON de cuentas de servicio, vinculando de forma segura una Kubernetes Service Account (KSA) con una Google Service Account (GSA). 

Sin embargo, habilitar la función es solo la mitad del trabajo. Una configuración segura requiere un mapeo **1:1**; si múltiples aplicaciones comparten la misma identidad de Google, un compromiso en una de ellas otorgaría acceso lateral a los recursos de las demás.

## Lógica de la Regla

La política audita el recurso `google_container_cluster` en dos fases:
1.  **Validación de Función:** Detecta si `workload_identity_config` está ausente, lo que obliga a los Pods a usar la identidad del nodo (riesgo alto).
2.  **Auditoría de Gobernanza:** Si la función está activa, alerta al auditor para que verifique manualmente en el código que cada microservicio tiene su propia vinculación dedicada.

## Casos de Fallo Detectados

---

### Caso 1: Workload Identity Deshabilitado
* **Descripción:** El clúster carece de la infraestructura necesaria para identidades granulares.
* **Ubicación de la Alerta:** Nivel de recurso `google_container_cluster`.

### Caso 2: Revisión de Mapeo de Identidades
* **Descripción:** La funcionalidad está activa, pero se requiere confirmar que no se están utilizando cuentas de servicio compartidas entre distintos microservicios.
* **Ubicación de la Alerta:** Bloque `workload_identity_config`.

## Recurso Involucrado

* `google_container_cluster`

## Solución

1.  Habilite Workload Identity en su recurso de clúster.
2.  Implemente vinculaciones granulares utilizando el rol `roles/iam.workloadIdentityUser`.

```terraform
resource "google_container_cluster" "compliant_cluster" {
  name     = "secure-cluster"
  location = "us-central1"

  # Habilitar la función
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# Ejemplo de vinculación manual a verificar (Mapeo 1:1)
resource "google_service_account_iam_member" "dedicated_binding" {
  service_account_id = google_service_account.app_specific_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[namespace/ksa-name]"
}