# Regla KICS: IBM Cloud API Keys Unused for 180 Days (Manual)

## Descripción General

Esta regla informativa (INFO) audita la creación de claves de API en **IBM Cloud**, cubriendo tanto las claves asociadas a usuarios (`ibm_iam_api_key`) como las asociadas a identidades de servicio o Service IDs (`ibm_iam_service_api_key`).

El cumplimiento de normativas de seguridad de la industria y las mejores prácticas de IBM Cloud exigen que las credenciales de acceso que no se hayan utilizado durante un periodo prolongado (típicamente 180 días) sean desactivadas o eliminadas para minimizar el riesgo de uso indebido. 

**Terraform no tiene visibilidad sobre el historial de uso en tiempo real** ni sobre la telemetría de autenticación de las claves que gestiona. Por lo tanto, esta regla actúa como un recordatorio crítico para que el equipo de seguridad implemente procesos de monitoreo externos (como scripts de auditoría con la CLI de IBM Cloud o integraciones con el Activity Tracker) que detecten y reaccionen ante claves inactivas.

## Lógica de la Regla

La política realiza las siguientes acciones:
1.  Identifica la creación de cualquier recurso `ibm_iam_api_key`.
2.  Identifica la creación de cualquier recurso `ibm_iam_service_api_key`.
3.  Genera una alerta informativa para cada clave detectada, instando al auditor a verificar que existe una política de ciclo de vida activa.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: API Key de Usuario Creada

* **Descripción:** Se ha definido una clave de API personal. Estas claves suelen tener privilegios amplios y deben ser vigiladas.
* **Ejemplo de Código Terraform:**
    ```terraform
    resource "ibm_iam_api_key" "my_key" {
      name = "user-api-key"
    }
    ```
* **Ubicación de la Alerta:** Recurso `ibm_iam_api_key`.

---

### Caso 2: API Key de Service ID Creada

* **Descripción:** Se ha definido una clave para una aplicación o servicio automatizado.
* **Ejemplo de Código Terraform:**
    ```terraform
    resource "ibm_iam_service_api_key" "service_key" {
      name           = "app-service-key"
      service_id_crn = ibm_iam_service_id.serviceID.crn
    }
    ```
* **Ubicación de la Alerta:** Recurso `ibm_iam_service_api_key`.

## Recursos Involucrados

* `ibm_iam_api_key`
* `ibm_iam_service_api_key`

## Solución

Establezca un proceso automatizado o una revisión periódica (fuera de Terraform) que consulte el estado de las claves. Puede usar la CLI de IBM Cloud para identificar claves inactivas:

```bash
# Ejemplo: Listar claves de API y verificar el campo 'Last Used'
ibmcloud iam api-keys --output json