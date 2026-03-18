# Regla KICS: IBM Owner Account API Key (Manual)

## Descripción General

Esta regla informativa (INFO) detecta la creación de claves de API de usuario (`ibm_iam_api_key`) en IBM Cloud para mitigar riesgos de privilegios excesivos.

Según las mejores prácticas de seguridad, como el **IBM Cloud Foundations Benchmark**, la cuenta propietaria (**Account Owner**) no debe tener claves de API activas. El propietario tiene privilegios absolutos sobre la facturación, gestión de identidades y la eliminación total de la cuenta. Las claves de API eluden el control de MFA (Autenticación Multi-Factor), por lo que una clave de propietario comprometida otorga control total e irreversible a un atacante.

## Lógica de la Regla

1.  Identifica recursos del tipo `ibm_iam_api_key`.
2.  Genera una alerta informativa que requiere validación manual. Dado que Terraform no tiene visibilidad del rol del usuario (Owner o no) en tiempo de escaneo estático, la regla alerta sobre cualquier clave de usuario creada.
3.  Esta regla **excluye** las claves de Service ID (`ibm_iam_service_api_key`), ya que estas son la alternativa segura recomendada y no pueden poseer el rol de "Account Owner".

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso 1: API Key de Usuario (Potencial Owner)

* **Descripción:** Se ha creado una clave de API personal. Se debe confirmar que el usuario que emite la clave no sea el propietario de la cuenta.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_iam_api_key" "personal_key" {
      name = "admin-key"
    }
    ```
* **Ubicación de la Alerta:** Recurso `ibm_iam_api_key`.

## Recurso Involucrado

* `ibm_iam_api_key`

## Solución

1.  Verifique en la consola de IAM que el usuario asociado a la clave no es el "Account Owner".
2.  Si lo es, elimine la clave y utilice un **Service ID** con permisos limitados mediante el principio de mínimo privilegio.

```terraform
# RECOMENDADO: Usar Service ID para automatizaciones
resource "ibm_iam_service_id" "app_identity" {
  name = "app-automation-id"
}

resource "ibm_iam_service_api_key" "app_key" {
  name           = "automation-key"
  iam_service_id = ibm_iam_service_id.app_identity.iam_id
}