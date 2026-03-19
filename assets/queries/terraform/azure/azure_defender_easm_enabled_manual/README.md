# Regla KICS: Microsoft Defender EASM Enabled (Manual)

## Descripción General

Esta regla funciona como un **recordatorio de cumplimiento manual**. Su objetivo es asegurar que se haya habilitado **Microsoft Defender External Attack Surface Monitoring (EASM)** para monitorear la exposición de los activos de Azure a Internet.

EASM realiza un descubrimiento continuo de tus activos digitales (direcciones IP, dominios, certificados SSL, etc.) para identificar vulnerabilidades y riesgos en la "sombra" (Shadow IT). Dado que el proveedor actual de Terraform para Azure no cuenta con recursos nativos para gestionar este servicio, la verificación debe realizarse directamente en la plataforma.

## Lógica de la Regla

Debido a las limitaciones del análisis estático para este servicio específico:
1.  La regla identifica la presencia de recursos `azurerm_resource_group`.
2.  Genera una alerta de severidad **INFO** por cada grupo detectado.
3.  Actúa como un check-list para que el equipo de seguridad valide el estado del servicio en el Portal de Azure.

## Casos de Fallo Detectados

### Caso 1: Verificación Manual Requerida

* **Descripción:** Se ha detectado infraestructura desplegada, pero el estado de protección de EASM no es visible para KICS.
* **Ubicación de la Alerta:** Sobre el recurso `azurerm_resource_group`.

## Recurso Involucrado

* `azurerm_resource_group`

## Solución

Esta alerta no se resuelve mediante cambios en el código HCL estándar. 

**Pasos de remediación manual:**
1.  Acceda al [Portal de Azure](https://portal.azure.com).
2.  En el buscador superior, escriba **"Microsoft Defender EASM"**.
3.  Verifique si existe un recurso EASM configurado y realizando escaneos activos.
4.  Si no existe, considere su creación para mejorar la postura de seguridad externa.
5.  Documente la verificación para cerrar el hallazgo en el reporte de KICS.