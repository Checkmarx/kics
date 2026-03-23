# KICS Rule: Elastic SAN Public Network Access Enabled

## General Description

This KICS rule verifies that Azure Elastic SAN volume groups (`azurerm_elastic_san_volume_group`) have public network access restricted.

In the Azure Elastic SAN architecture, network security and isolation are not managed at the root SAN resource level, but at the **Volume Group** level. To ensure that data volumes are not accessible from the Internet, it is essential to define the `network_rule` block. The mere presence of this block activates an implicit deny policy for any traffic that does not originate from authorized subnets, ensuring that the infrastructure is only accessible through the private network.

## Rule Logic

The policy audits the `azurerm_elastic_san_volume_group` resource by analyzing the following condition:
1.  **Network Block Existence:** The presence of the `network_rule` block is verified. If this block is not defined, the volume group lacks perimeter restrictions, potentially allowing public access.

## Detected Failure Case

The following describes the scenario this policy will detect.

---

### Single Case: Missing Network Configuration

* **Description:** The volume group is defined without the `network_rule` block, meaning no IP filtering or virtual network rules are being applied to protect the data.
* **Example of Problematic Terraform Code:**
    ```terraform
    resource "azurerm_elastic_san_volume_group" "example_insecure" {
      name           = "insecure-vg"
      elastic_san_id = azurerm_elastic_san.example.id

      # The resource lacks the network_rule block,
      # leaving it exposed to public networks.
    }
    ```
* **Alert Location:** On the root `azurerm_elastic_san_volume_group` resource.

## Involved Resource

* `azurerm_elastic_san_volume_group`

## Solution

To fix this security risk, define the `network_rule` block linking it to an authorized subnet via the `subnet_id` attribute.

```terraform
resource "azurerm_elastic_san_volume_group" "secure_vg" {
  name           = "secure-volume-group"
  elastic_san_id = azurerm_elastic_san.example.id

  # SOLUTION: Define network rules to deny public access
  network_rule {
    subnet_id = azurerm_subnet.example.id
  }
}
