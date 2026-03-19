# Regla KICS: GKE Security Posture Disabled (Manual)

## Descripción General

Esta regla informativa (**INFO**) de **Observabilidad** verifica si el **Security Posture Dashboard** de GKE está activo en la configuración del clúster.

El panel de postura de seguridad es una herramienta nativa de Google Cloud que escanea automáticamente las cargas de trabajo de Kubernetes en busca de errores de configuración comunes y vulnerabilidades conocidas en las imágenes de los contenedores. Proporciona recomendaciones accionables para mejorar la seguridad sin añadir complejidad operativa. Dado que la disponibilidad de esta función puede variar según el canal de versiones de GKE y el tipo de licencia (Standard vs Autopilot), esta regla alerta sobre su ausencia para permitir una verificación manual de compatibilidad.

## Lógica de la Regla

La política audita el recurso `google_container_cluster` identificando dos escenarios:
1.  **Omisión:** El bloque `security_posture_config` no está presente en el código Terraform.
2.  **Desactivación:** El bloque existe pero el parámetro `mode` se ha establecido explícitamente como `DISABLED`.

## Casos de Fallo Detectados

---

### Caso 1: Configuración de Postura Ausente
* **Descripción:** El clúster no ha habilitado el panel de control de seguridad. Se recomienda verificar si la versión de GKE permite su activación.
* **Ubicación de la Alerta:** Nivel de recurso `google_container_cluster`.

### Caso 2: Modo de Postura Deshabilitado
* **Descripción:** Se ha configurado la postura de seguridad pero se ha desactivado mediante el valor `DISABLED`.
* **Ubicación de la Alerta:** Atributo `mode` dentro de `security_posture_config`.

## Recurso Involucrado

* `google_container_cluster`

## Solución

Habilite la postura de seguridad configurando el modo en `BASIC` o `ENTERPRISE`.

```terraform
resource "google_container_cluster" "compliant_cluster" {
  name     = "monitored-cluster"
  location = "us-central1"

  # Solución recomendada para observabilidad de seguridad
  security_posture_config {
    mode               = "BASIC"
    vulnerability_mode = "VULNERABILITY_BASIC"
  }
}