package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_redis_cache[name]
    not common_lib.valid_key(resource, "public_network_access_enabled")
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_redis_cache",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_redis_cache[%s]", [name]),
        "issueType": "MissingAttribute",
        "keyExpectedValue": sprintf("azurerm_redis_cache[%s].public_network_access_enabled should be false", [name]),
        "keyActualValue": sprintf("azurerm_redis_cache[%s].public_network_access_enabled is not defined (defaults to true)", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name], []),
    }
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_redis_cache[name]
    resource.public_network_access_enabled == true
    result := {
        "documentId": input.document[i].id,
        "resourceType": "azurerm_redis_cache",
        "resourceName": terra_lib.get_resource_name(resource, name),
        "searchKey": sprintf("azurerm_redis_cache[%s].public_network_access_enabled", [name]),
        "issueType": "IncorrectValue",
        "keyExpectedValue": sprintf("azurerm_redis_cache[%s].public_network_access_enabled should be false", [name]),
        "keyActualValue": sprintf("azurerm_redis_cache[%s].public_network_access_enabled is true", [name]),
        "searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "public_network_access_enabled"], []),
    }
}
