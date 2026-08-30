package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_container_registry[name]
    resource.admin_enabled == true
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_container_registry",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_container_registry[%s].admin_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_container_registry[%s].admin_enabled should be false", [name]),
        "keyActualValue": sprintf("azurerm_container_registry[%s].admin_enabled is true", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_container_registry", name, "admin_enabled"], []),
    }
}
