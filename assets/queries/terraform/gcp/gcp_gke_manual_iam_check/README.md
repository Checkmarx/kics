# Regla KICS: GKE Service Account IAM Review (Manual)

## Descripción General

Esta regla informativa (INFO) de **Supply Chain** audita las identidades utilizadas por los nodos de **Google Kubernetes Engine (GKE)** cuando se han configurado cuentas de servicio personalizadas.

El uso de cuentas de servicio personalizadas es el primer paso hacia el principio de menor privilegio. Sin embargo, si a esta cuenta se le asignan roles con permisos de escritura (como `roles/artifactregistry.writer` o `roles/storage.objectAdmin`), un atacante que comprometa un nodo podría modificar o reemplazar las imágenes de contenedor en el registro. Esto permitiría ataques de persistencia o escalada de privilegios en otros clústeres que consuman esas mismas imágenes.

## Lógica de la Regla

La política identifica los recursos `google_container_cluster` y `google_container_node_pool` que definen explícitamente una `service_account`. Al ser una verificación manual, genera una alerta informativa sobre la línea de la cuenta de servicio para que el auditor valide en el proyecto de GCP que los roles asociados son exclusivamente de **Lectura**.

## Casos de Fallo Detectados

---

### Caso 1: Revisión de SA en Clúster
* **Descripción:** Se ha definido una identidad personalizada para el clúster. Se debe verificar que no tenga permisos de "Push" al registro de imágenes.
* **Ubicación de la Alerta:** Atributo `service_account` en `google_container_cluster`.

### Caso 2: Revisión de SA en Node Pool
* **Descripción:** Un pool de nodos específico utiliza una identidad propia que requiere auditoría de roles IAM.
* **Ubicación de la Alerta:** Atributo `service_account` en `google_container_node_pool`.

## Recurso Involucrado

* `google_container_cluster`
* `google_container_node_pool`

## Solución

Asegúrese de que la Service Account asignada solo posea roles de lectura para el registro de imágenes utilizado.

**Roles Recomendados:**
* `roles/artifactregistry.reader` (para Artifact Registry)
* `roles/storage.objectViewer` (para Container Registry/GCR)
* `roles/logging.logWriter`
* `roles/monitoring.metricWriter`