# Regla KICS: Restrict API Key & Service ID Creation (Manual)

## Descripción General

Esta regla informativa (INFO) audita las asignaciones de roles en **IBM Cloud IAM** para asegurar que la capacidad de crear identidades y credenciales esté estrictamente controlada.

Según los controles de seguridad **CIS IBM Cloud Foundations**, la creación de **claves de API de usuario** y **Service IDs** es una acción de alto privilegio que debe restringirse a un número mínimo de usuarios de confianza. En IBM Cloud, roles predefinidos de plataforma como `Administrator` o `Editor` sobre el servicio de identidad incluyen permisos potentes como `iam.service_id.create` o `iam.api_key.create`.

Esta regla identifica las definiciones de políticas para que un auditor verifique que estos roles no se estén asignando de forma masiva o a sujetos que no requieren capacidades administrativas de identidad, cumpliendo con el **Principio de Mínimo Privilegio**.

## Lógica de la Regla

La política realiza las siguientes acciones:
1.  Identifica recursos `ibm_iam_user_policy` y `ibm_iam_access_group_policy`.
2.  Extrae y evalúa la lista de roles asignados en cada política.
3.  Genera una alerta para que se verifique manualmente si los roles asignados (especialmente Administrator o Editor) son estrictamente necesarios para el propósito del usuario o grupo.

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Revisión de Roles en Políticas de Usuario
* **Descripción:** Se asignan roles directamente a una identidad de usuario.
* **Ubicación de la Alerta:** Atributo `roles` dentro de `ibm_iam_user_policy`.

### Caso 2: Revisión de Roles en Políticas de Grupo
* **Descripción:** Se asignan roles a un Grupo de Acceso (Access Group), afectando a todos sus miembros.
* **Ubicación de la Alerta:** Atributo `roles` dentro de `ibm_iam_access_group_policy`.

## Recurso Involucrado

* `ibm_iam_user_policy`
* `ibm_iam_access_group_policy`

## Solución

Revisa los roles asignados. Evita otorgar roles de plataforma amplios como `Editor` o `Administrator` de forma generalizada. Si un usuario solo necesita gestionar recursos existentes, utiliza el rol `Operator` o `Viewer`. Si se requiere una granularidad mayor, implemente **Roles Personalizados (Custom Roles)** que omitan específicamente las acciones de creación de identidades.

```terraform
# Ejemplo de política restrictiva usando roles de menor privilegio
resource "ibm_iam_access_group_policy" "restricted_group_policy" {
  access_group_id = ibm_iam_access_group.group.id
  roles           = ["Viewer", "Operator"] # Roles que no permiten creación de IDs/Keys
  
  resources {
    service = "is" # VPC Infrastructure
  }
}