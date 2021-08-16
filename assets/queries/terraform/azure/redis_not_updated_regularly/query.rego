package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	redis_cache := input.document[i].resource.azurerm_redis_cache[name]

	not common_lib.valid_key(redis_cache, "patch_schedule")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_redis_cache[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_redis_cache[%s].patch_schedule' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_redis_cache[%s].patch_schedule' is undefined or null", [name]),
	}
}
