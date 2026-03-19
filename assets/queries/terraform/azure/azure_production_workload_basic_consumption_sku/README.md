# Regla KICS: Production Workload using Basic or Consumption SKU

## Descripción General

Esta regla identifica recursos de Azure configurados con niveles de precios (SKUs) de tipo **Basic**, **Free** o **Consumption**.

Aunque estos niveles son ideales para entornos de desarrollo, aprendizaje o pruebas de concepto (PoC), carecen de características fundamentales necesarias para entornos de producción. El uso de estos SKUs en producción compromete la fiabilidad del servicio debido a la ausencia de Acuerdos de Nivel de Servicio (SLA) garantizados, falta de soporte para integración con redes virtuales (VNet), ausencia de slots de implementación y latencias imprevistas ("cold starts") en modelos de consumo serverless.

## Lógica de la Regla

La política audita los siguientes recursos en la configuración de Terraform:
1.  **Service Plans (`azurerm_service_plan`):** Alerta si el atributo `sku_name` se establece en niveles no productivos como B1-B3, F1, FREE o Y1.
2.  **API Management (`azurerm_api_management`):** Alerta si el atributo `sku_name` coincide con patrones de tipo "Basic" o "Consumption".

## Casos de Fallo Detectados

A continuación se describen los escenarios que esta política detectará.

---

### Caso 1: Service Plan en Nivel No-Productivo

* **Descripción:** Se detecta un plan de App Service configurado en nivel Basic o Free, lo cual limita la disponibilidad y las capacidades de red del servicio.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_service_plan" "fail_plan" {
      name                = "example-basic-plan"
      resource_group_name = "rg-production"
      location            = "West Europe"
      os_type             = "Linux"
      sku_name            = "B1" # <-- FALLO: Nivel Basic
    }
    ```
* **Ubicación de la Alerta:** Atributo `sku_name`.

---

### Caso 2: API Management en Modo Consumo

* **Descripción:** Se detecta una instancia de APIM en nivel Consumption (Serverless), lo que puede afectar al rendimiento y carece de aislamiento de red.
* **Ejemplo de Código Terraform Problemático:**
    ```terraform
    resource "azurerm_api_management" "fail_apim" {
      name                = "example-apim"
      sku_name            = "Consumption_0" # <-- FALLO: Nivel Consumption
      # ... resto de la configuración ...
    }
    ```
* **Ubicación de la Alerta:** Atributo `sku_name`.

## Recurso Involucrado

* `azurerm_service_plan`
* `azurerm_api_management`

## Solución

Actualice el SKU del recurso a un nivel orientado a producción, como **Standard (S)** o **Premium (P)**, para garantizar el SLA y las funciones de red necesarias.

```terraform
resource "azurerm_service_plan" "secure_production" {
  name                = "prod-service-plan"
  resource_group_name = "rg-production"
  location            = "West Europe"
  os_type             = "Linux"

  # SOLUCIÓN: Usar un nivel Standard o superior
  sku_name            = "S1"
}