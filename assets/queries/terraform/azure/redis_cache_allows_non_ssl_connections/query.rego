package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	cache := input.document[i].resource.azurerm_redis_cache[name]
	cache.enable_non_ssl_port == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(cache, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].enable_non_ssl_port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_redis_cache[%s].enable_non_ssl_port' is false or undefined (false as default)", [name]),
		"keyActualValue": sprintf("'azurerm_redis_cache[%s].enable_non_ssl_port' is true", [name]),
	}
}
