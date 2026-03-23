# KICS Rule: Azure IoT Hub Defender Disabled

## General Description

This KICS rule verifies that **Azure IoT Hub** resources (`azurerm_iothub`) are protected by **Microsoft Defender for IoT**.

Microsoft Defender for IoT provides an essential layer of security for Internet of Things environments, offering real-time threat detection and security posture management. The lack of this protection leaves IoT devices and the Hub's central infrastructure vulnerable to targeted attacks, lateral movement, and data exfiltration. In Terraform, this protection is enabled by linking the IoT Hub with a resource of type `azurerm_iot_security_solution`.

## Rule Logic

The policy analyzes the Terraform configuration by performing the following steps:
1.  **Hub Identification:** Selects all resources of type `azurerm_iothub`.
2.  **Solution Verification:** Looks for `azurerm_iot_security_solution` resources in the document.
3.  **Link Validation:** Checks whether the Hub's identifier is present in the `iothub_ids` list of any defined security solution, considering direct or interpolated formats.
4.  **Alert Generation:** If a Hub is not referenced in any solution, a security finding is generated.

## Detected Failure Case

The following describes the scenario this policy will detect.

---

### Single Case: IoT Hub without Associated Defender

* **Description:** An `azurerm_iothub` resource is defined but no `azurerm_iot_security_solution` resource is found that includes it in its list of protected IDs.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_iothub" "fail_hub" {
      name                = "insecure-iothub"
      resource_group_name = azurerm_resource_group.example.name
      location            = azurerm_resource_group.example.location

      sku {
        name     = "S1"
        capacity = "1"
      }
    }

    # No azurerm_iot_security_solution exists that references fail_hub
    ```
* **Alert Location:** On the root `azurerm_iothub` resource.

## Involved Resource

* `azurerm_iothub`
* `azurerm_iot_security_solution`

## Solution

To fix this risk, make sure to define an `azurerm_iot_security_solution` resource and include the IoT Hub ID in the `iothub_ids` attribute.

```terraform
resource "azurerm_iothub" "example" {
  name                = "secure-iothub"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  sku {
    name     = "S1"
    capacity = "1"
  }
}

# SOLUTION: Define the security solution and link the Hub
resource "azurerm_iot_security_solution" "example" {
  name                = "iot-security-solution"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  display_name        = "Iot Security Solution"

  iothub_ids          = [azurerm_iothub.example.id]
}
