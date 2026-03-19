# Regla KICS: GKE Metadata Server Disabled

## Descripción General

Esta regla de severidad **ALTA** verifica que los nodos de GKE utilicen el **GKE Metadata Server** para gestionar las identidades de las cargas de trabajo.

Por defecto, los nodos de GKE tienen acceso al servidor de metadatos de Compute Engine (GCE), el cual expone información sensible del host y tokens de acceso de la cuenta de servicio del nodo. Si un atacante logra comprometer un pod, podría consultar este endpoint para obtener credenciales y realizar un movimiento lateral hacia otros recursos del proyecto. Al habilitar `GKE_METADATA`, se activa el puente hacia **Workload Identity**, interceptando estas peticiones y limitando el acceso solo a lo que el Pod tiene permitido específicamente.

## Lógica de la Regla

La política audita los recursos `google_container_cluster` y `google_container_node_pool` bajo dos criterios:
1.  **Omisión del Bloque:** Verifica si `workload_metadata_config` está presente dentro de `node_config`.
2.  **Modo Inseguro:** Asegura que el atributo `mode` sea estrictamente `GKE_METADATA`. El valor `GCE_METADATA` (valor predeterminado heredado) se considera vulnerable.

## Casos de Fallo Detectados

---

### Caso 1: Configuración de Metadatos Ausente
* **Descripción:** El clúster o pool de nodos no define el modo de metadatos de carga de trabajo.
* **Ubicación de la Alerta:** Atributo `node_config`.

### Caso 2: Uso de GCE_METADATA (Legacy/Vulnerable)
* **Descripción:** Se permite explícitamente el acceso de los pods a los metadatos de la instancia de cómputo subyacente.
* **Ubicación de la Alerta:** Atributo `mode` dentro de `workload_metadata_config`.

## Recurso Involucrado

* `google_container_cluster`
* `google_container_node_pool`

## Solución

Configure el bloque `workload_metadata_config` con el modo `GKE_METADATA`.

```terraform
resource "google_container_node_pool" "compliant_pool" {
  name    = "secure-pool"
  cluster = google_container_cluster.primary.name

  node_config {
    # Solución técnica
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}