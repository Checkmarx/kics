# Regla KICS: GCP Access Approval Disabled

## Descripción General

Esta regla de severidad **MEDIA** audita el cumplimiento del control de acceso de terceros en **Google Cloud (GCP)** para los recursos `google_project`.

**Access Approval** es un control de seguridad avanzado que permite a las organizaciones establecer un paso de aprobación explícito antes de que el personal de Google (Ingeniería o Soporte) pueda acceder a los datos de sus clientes. Mientras que Google cifra los datos por defecto y restringe el acceso mediante políticas internas, Access Approval otorga al cliente la soberanía final: cualquier intento de acceso genera una solicitud por correo electrónico o mediante Cloud Pub/Sub que el cliente debe aprobar manualmente. 

Sin esta configuración, se asume que el personal de Google puede acceder a los recursos para fines de soporte técnico bajo los términos estándar del contrato, lo que puede no ser suficiente para empresas bajo regulaciones estrictas.

## Lógica de la Regla

La política realiza dos validaciones en el código Terraform:
1.  **Existencia de la Configuración:** Detecta si un `google_project` carece de un recurso `google_access_approval_project_settings` que lo gestione.
2.  **Inscripción de Servicios:** Verifica que, de existir la configuración, esta incluya al menos un bloque `enrolled_services`. Un recurso de configuración sin servicios inscritos no protege activamente ningún producto de GCP.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Proyecto sin Access Approval
* **Descripción:** Se provisiona un proyecto en GCP pero no se implementa el flujo de aprobación de acceso de Google.
* **Ubicación de la Alerta:** Bloque del recurso `google_project`.

### Caso 2: Configuración de Servicios Ausente
* **Descripción:** Se define el recurso de configuración de Access Approval pero se deja vacío el bloque de servicios protegidos.
* **Ubicación de la Alerta:** Recurso `google_access_approval_project_settings`.

## Recursos Involucrados

* `google_project`
* `google_access_approval_project_settings`

## Solución

Defina el recurso de configuración y asegúrese de inscribir los servicios deseados (o `all` para una cobertura total).

```terraform
resource "google_access_approval_project_settings" "compliant_settings" {
  project_id = google_project.my_secure_project.project_id

  enrolled_services {
    cloud_product = "all" # Protege todos los productos compatibles
    enrollment_level = "BLOCK_ALL"
  }
  
  notification_emails = ["security-team@tu-empresa.com"]
}