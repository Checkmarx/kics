# KICS Rule: Production Workload using Basic or Consumption SKU

## General Description

This rule identifies Azure resources configured with **Basic**, **Free**, or **Consumption** pricing tiers (SKUs).

Although these tiers are ideal for development, learning, or proof-of-concept (PoC) environments, they lack fundamental features required for production environments. Using these SKUs in production compromises service reliability due to the absence of guaranteed Service Level Agreements (SLAs), lack of support for virtual network (VNet) integration, absence of deployment slots, and unexpected latencies ("cold starts") in serverless consumption models.

## Rule Logic

The policy audits the following resources in the Terraform configuration:
1.  **Service Plans (`azurerm_service_plan`):** Alerts if the `sku_name` attribute is set to non-production tiers such as B1-B3, F1, FREE, or Y1.
2.  **API Management (`azurerm_api_management`):** Alerts if the `sku_name` attribute matches patterns of type "Basic" or "Consumption".

## Detected Failure Cases

The following describes the scenarios this policy will detect.

---

### Case 1: Service Plan at Non-Production Tier

* **Description:** An App Service plan is detected configured at Basic or Free tier, which limits the availability and network capabilities of the service.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_service_plan" "fail_plan" {
      name                = "example-basic-plan"
      resource_group_name = "rg-production"
      location            = "West Europe"
      os_type             = "Linux"
      sku_name            = "B1" # <-- FAILURE: Basic Tier
    }
    ```
* **Alert Location:** `sku_name` attribute.

---

### Case 2: API Management in Consumption Mode

* **Description:** An APIM instance is detected at the Consumption (Serverless) tier, which may affect performance and lacks network isolation.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_api_management" "fail_apim" {
      name                = "example-apim"
      sku_name            = "Consumption_0" # <-- FAILURE: Consumption Tier
      # ... rest of configuration ...
    }
    ```
* **Alert Location:** `sku_name` attribute.

## Involved Resource

* `azurerm_service_plan`
* `azurerm_api_management`

## Solution

Update the resource SKU to a production-oriented tier, such as **Standard (S)** or **Premium (P)**, to guarantee the SLA and the necessary network features.

```terraform
resource "azurerm_service_plan" "secure_production" {
  name                = "prod-service-plan"
  resource_group_name = "rg-production"
  location            = "West Europe"
  os_type             = "Linux"

  # SOLUTION: Use a Standard tier or higher
  sku_name            = "S1"
}
