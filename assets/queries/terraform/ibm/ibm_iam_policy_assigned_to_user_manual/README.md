# Regla KICS: IBM IAM Policies Attached to Users (Manual)

## Descripción General

Esta regla informativa (INFO) detecta el uso del recurso `ibm_iam_user_policy` en Terraform.

La asignación de permisos basada en grupos (**RBAC**) es el pilar de una gobernanza de identidades robusta. Las mejores prácticas de IBM Cloud y marcos de cumplimiento como CIS recomiendan gestionar los permisos a través de **Grupos de Acceso** (Access Groups) en lugar de asignar políticas directamente a usuarios individuales. 

La asignación directa usuario a usuario crea una infraestructura "snowflake" donde cada identidad tiene permisos únicos, lo que hace casi imposible auditar el impacto de cambios globales o garantizar el principio de mínimo privilegio. El uso de grupos facilita el "onboarding" y "offboarding" de usuarios y centraliza el control de acceso.

## Lógica de la Regla

1.  Escanea el código de Terraform en busca del recurso `ibm_iam_user_policy`.
2.  Genera una alerta para cada ocurrencia detectada.
3.  El auditor debe verificar si esta asignación directa está realmente justificada (como en el caso de cuentas de administración de emergencia o "break-glass") o si debe ser refactorizada para integrarse en un grupo de acceso.

## Casos de Fallo Detectados

A continuación se describe el escenario que esta política detectará.

---

### Caso 1: Asignación de Política Directa a Usuario

* **Descripción:** Se utiliza el recurso `ibm_iam_user_policy` para otorgar roles a una identidad de usuario específica.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "ibm_iam_user_policy" "direct_access" {
      ibm_id = "user@example.com"
      roles  = ["Administrator"]
      
      resources {
        service = "is"
      }
    }
    ```
* **Ubicación de la Alerta:** Recurso `ibm_iam_user_policy`.

## Recurso Involucrado

* `ibm_iam_user_policy`

## Solución

La práctica recomendada consiste en crear un grupo de acceso, asignar la política a dicho grupo y posteriormente añadir a los usuarios como miembros.

```terraform
# PATRÓN CORRECTO Y ESCALABLE
resource "ibm_iam_access_group" "admins" {
  name = "Cloud-Administrators"
}

resource "ibm_iam_access_group_policy" "admin_policy" {
  access_group_id = ibm_iam_access_group.admins.id
  roles           = ["Administrator"]
  
  resources {
    service = "is"
  }
}

resource "ibm_iam_access_group_members" "admin_members" {
  access_group_id = ibm_iam_access_group.admins.id
  ibm_ids         = ["user@example.com"]
}