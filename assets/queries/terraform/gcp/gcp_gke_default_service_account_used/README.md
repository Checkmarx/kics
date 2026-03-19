# Regla KICS: GKE Default Service Account Used

## Descripción General

Esta regla de severidad **ALTA** verifica que los clústeres y pools de nodos de **Google Kubernetes Engine (GKE)** no utilicen la cuenta de servicio predeterminada de Compute Engine.

Por defecto, si no se especifica el atributo `service_account`, GKE utiliza la cuenta de servicio predeterminada del proyecto (`PROJECT_NUMBER-compute@developer.gserviceaccount.com`). Esta cuenta posee automáticamente el rol de **Editor**, lo que otorga a los nodos (y potencialmente a los Pods) permisos extensos para modificar recursos en GCP, como buckets de almacenamiento, redes VPC y otras instancias. Utilizar una cuenta de servicio dedicada con privilegios mínimos reduce drásticamente el "blast radius" en caso de un compromiso de seguridad en el clúster.

## Lógica de la Regla

La política audita los recursos `google_container_cluster` y `google_container_node_pool` bajo los siguientes criterios:
1.  **Falta de Atributo:** Identifica si el bloque `node_config` carece de la clave `service_account`.
2.  **Identificación de Riesgo:** La alerta se dispara al detectar que el clúster delegará su identidad a la cuenta de servicio más privilegiada del proyecto por defecto.

## Casos de Fallo Detectados

---

### Caso 1: Uso Implícito en el Clúster
* **Descripción:** Se define un clúster de GKE sin especificar una identidad para los nodos.
* **Ubicación de la Alerta:** Atributo `node_config` del recurso `google_container_cluster`.

### Caso 2: Uso Implícito en el Node Pool
* **Descripción:** Se crea un pool de nodos adicional que hereda la cuenta de servicio por defecto.
* **Ubicación de la Alerta:** Atributo `node_config` del recurso `google_container_node_pool`.

## Recurso Involucrado

* `google_container_cluster`
* `google_container_node_pool`

## Solución

Cree una Service Account personalizada con los permisos mínimos necesarios (ej. roles de logging, monitoring y acceso a registry) y asígnela explícitamente.

```terraform
resource "google_service_account" "gke_nodes_sa" {
  account_id   = "gke-nodes-identity"
  display_name = "GKE Nodes Minimal Service Account"
}

resource "google_container_cluster" "secure_cluster" {
  name     = "production-cluster"
  location = "us-central1"

  node_config {
    # Solución: Identidad dedicada
    service_account = google_service_account.gke_nodes_sa.email
    oauth_scopes    = ["[https://www.googleapis.com/auth/cloud-platform](https://www.googleapis.com/auth/cloud-platform)"]
  }
}