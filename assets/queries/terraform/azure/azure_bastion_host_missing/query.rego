package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: A VNet exists but no azurerm_bastion_host is declared in the same document.
# Note: this is a document-level check; Bastion association to a specific VNet subnet
# cannot be verified without cross-resource reference resolution.
CxPolicy[result] {
    doc := input.document[i]

    vnet := doc.resource.azurerm_virtual_network[name]

    count([b | b := doc.resource.azurerm_bastion_host[_]]) == 0

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_virtual_network",
        "resourceName": tf_lib.get_resource_name(vnet, name),
        "searchKey": sprintf("azurerm_virtual_network[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_virtual_network", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("An 'azurerm_bastion_host' resource should be defined to protect Virtual Network '%s'", [name]),
        "keyActualValue": "No 'azurerm_bastion_host' resource was found in the configuration",
    }
}

# RULE 2: An azurerm_bastion_host is declared but missing the required ip_configuration block.
# ip_configuration is mandatory in the Terraform schema and must reference a dedicated
# subnet named 'AzureBastionSubnet' and a Standard-tier public IP address.
CxPolicy[result] {
    doc := input.document[i]

    bastion := doc.resource.azurerm_bastion_host[name]
    not bastion.ip_configuration

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_bastion_host",
        "resourceName": tf_lib.get_resource_name(bastion, name),
        "searchKey": sprintf("azurerm_bastion_host[%s]", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_bastion_host", name], []),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("'azurerm_bastion_host.%s' should have an 'ip_configuration' block referencing an 'AzureBastionSubnet' subnet", [name]),
        "keyActualValue": sprintf("'azurerm_bastion_host.%s' is missing the required 'ip_configuration' block", [name]),
    }
}
