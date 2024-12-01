package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	redis_cache := document.resource.azurerm_redis_cache[name]

	not common_lib.valid_key(redis_cache, "patch_schedule")

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(redis_cache, name),
		"searchKey": sprintf("azurerm_redis_cache[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_redis_cache[%s].patch_schedule' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_redis_cache[%s].patch_schedule' is undefined or null", [name]),
	}
}
