# Regla KICS: OCI Service Level Admins (Manual)

## Descripción General

Esta regla informativa (INFO) audita las políticas de **OCI IAM** (`oci_identity_policy`).

Según el Benchmark CIS para Oracle Cloud, se debe evitar el uso excesivo del grupo de administradores predeterminado (que tiene acceso total a la tenencia). En su lugar, se deben crear **Administradores de Nivel de Servicio** (Service Level Admins). Esto implica crear grupos y políticas específicas para gestionar verticales tecnológicas, por ejemplo:
* `NetworkAdmins`: `manage virtual-network-family`
* `ComputeAdmins`: `manage instance-family`
* `StorageAdmins`: `manage object-family`

Esta regla detecta cualquier política que otorgue el verbo `manage` para que un auditor verifique que está correctamente acotada (es decir, que no sea `manage all-resources` a menos que sea estrictamente necesario).

## Lógica de la Regla

1.  Identifica recursos `oci_identity_policy`.
2.  Analiza el array `statements`.
3.  Si una sentencia contiene la palabra exacta `manage` (usando detección de límite de palabra y sin distinguir mayúsculas/minúsculas), genera una alerta para su revisión manual.

## Casos de Fallo Detectados

### Caso 1: Privilegios de Gestión (Manage)

* **Descripción:** Se detectó una política que otorga control total (`manage`) sobre algún recurso o familia de recursos.
* **Acción:** Verificar que el grupo asignado y el recurso gestionado ("family") corresponden a una segregación de funciones adecuada.
* **Ubicación de la Alerta:** Atributo `statements` en `oci_identity_policy`.

## Recurso Involucrado

* `oci_identity_policy`

## Solución

Define políticas granulares por familia de servicios.

```terraform
resource "oci_identity_policy" "network_admin_policy" {
  name           = "NetworkAdminPolicy"
  description    = "Policy for Network Admins"
  compartment_id = var.tenancy_ocid

  statements = [
    "Allow group NetworkAdmins to manage virtual-network-family in tenancy",
    "Allow group NetworkAdmins to read all-resources in tenancy"
  ]
}