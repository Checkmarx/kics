package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

# RULE 1: A VNet exists, but no azurerm_bastion_host resource exists in the document.
CxPolicy[result] {
    doc := input.document[i]

    vnet := doc.resource.azurerm_virtual_network[name]

    bastions := [b | b := doc.resource.azurerm_bastion_host[_]]

    count(bastions) == 0

    result := {
        "documentId": doc.id,
        "resourceType": "azurerm_virtual_network",
        "resourceName": tf_lib.get_resource_name(vnet, name),
        "searchKey": sprintf("azurerm_virtual_network[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("An 'azurerm_bastion_host' resource should be defined to protect Virtual Network '%s'", [name]),
        "keyActualValue": "No 'azurerm_bastion_host' resource was found in the configuration",
    }
}
