package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	cache := input.document[i].resource.azurerm_redis_cache[name]
	cache.enable_non_ssl_port == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(cache, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].enable_non_ssl_port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_redis_cache[%s].enable_non_ssl_port' should be set to false or undefined (false as default)", [name]),
		"keyActualValue": sprintf("'azurerm_redis_cache[%s].enable_non_ssl_port' is true", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_redis_cache" ,name, "enable_non_ssl_port"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
