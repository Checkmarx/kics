package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_data_factory[name]
    not common_lib.valid_key(resource, "public_network_enabled")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_data_factory",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_data_factory[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_data_factory[%s].public_network_enabled should be false", [name]),
        "keyActualValue": sprintf("azurerm_data_factory[%s].public_network_enabled is not defined (defaults to true)", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_data_factory[name]
    resource.public_network_enabled == true
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_data_factory",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_data_factory[%s].public_network_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_data_factory[%s].public_network_enabled should be false", [name]),
        "keyActualValue": sprintf("azurerm_data_factory[%s].public_network_enabled is true", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_data_factory", name, "public_network_enabled"], []),
    }
}
