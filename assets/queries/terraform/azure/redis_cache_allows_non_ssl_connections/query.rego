package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	cache := document.resource.azurerm_redis_cache[name]
	cache.enable_non_ssl_port == true

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(cache, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].enable_non_ssl_port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_redis_cache[%s].enable_non_ssl_port' should be set to false or undefined (false as default)", [name]),
		"keyActualValue": sprintf("'azurerm_redis_cache[%s].enable_non_ssl_port' is true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "enable_non_ssl_port"], []),
		"remediation": json.marshal({
			"before": "true",
			"after": "false",
		}),
		"remediationType": "replacement",
	}
}
