# Regla KICS: GKE Sandbox (gVisor) Disabled

## Descripción General

Esta regla de severidad **BAJA** verifica si los pools de nodos de GKE tienen habilitado **GKE Sandbox (gVisor)** para un aislamiento reforzado.

GKE Sandbox utiliza **gVisor**, un kernel de espacio de usuario que proporciona una barrera de seguridad adicional entre las aplicaciones y el kernel del host. Al interceptar y filtrar las llamadas al sistema, gVisor mitiga el riesgo de ataques de escape de contenedor, donde un proceso malicioso intenta comprometer el nodo subyacente. Aunque gVisor introduce un ligero overhead de rendimiento, es una **Configuración Insegura** omitirlo en entornos que ejecutan código no confiable o aplicaciones multi-tenant.

## Lógica de la Regla

La política audita los recursos `google_container_cluster` y `google_container_node_pool`:
1.  **Omisión del Bloque:** Detecta si `sandbox_config` no está presente en el `node_config`.
2.  **Tipo Incorrecto:** Verifica que el `sandbox_type` sea explícitamente `"gvisor"`.

## Casos de Fallo Detectados

---

### Caso 1: Sandbox no configurado en Clúster
* **Descripción:** Los nodos predeterminados del clúster no utilizan el aislamiento de gVisor.
* **Ubicación de la Alerta:** Atributo `node_config`.

### Caso 2: Sandbox no configurado en Node Pool
* **Descripción:** Se ha creado un pool de nodos adicional que carece de protección de Sandbox.
* **Ubicación de la Alerta:** Atributo `node_config`.

### Caso 3: Tipo de Sandbox Inseguro
* **Descripción:** Se define el bloque pero se utiliza un valor distinto a `gvisor`, lo que desactiva la protección buscada.
* **Ubicación de la Alerta:** Atributo `sandbox_type`.

## Recurso Involucrado

* `google_container_cluster`
* `google_container_node_pool`

## Solución

Habilite gVisor asegurándose de usar el tipo de imagen compatible `COS_CONTAINERD`.

```terraform
resource "google_container_node_pool" "secure_pool" {
  name    = "untrusted-code-pool"
  cluster = google_container_cluster.primary.name

  node_config {
    image_type = "COS_CONTAINERD"
    
    sandbox_config {
      sandbox_type = "gvisor"
    }
  }
}