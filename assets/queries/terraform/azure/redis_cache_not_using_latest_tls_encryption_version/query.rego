package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_redis_cache[name]

    common_lib.valid_key(resource, "minimum_tls_version")
    resource.minimum_tls_version != "1.2"
    tls_version_val := resource.minimum_tls_version

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_redis_cache[%s].minimum_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'minimum_tls_version' should be defined and set to '1.2'",
		"keyActualValue": sprintf("'minimum_tls_version' is defined to '%s'", [tls_version_val]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name, "minimum_tls_version"], []),
		"remediation": json.marshal({
			"before": tls_version_val,
			"after": "1.2",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
    resource := input.document[i].resource.azurerm_redis_cache[name]

    not common_lib.valid_key(resource, "minimum_tls_version")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_redis_cache",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_redis_cache[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'minimum_tls_version' should be defined and set to '1.2'",
		"keyActualValue": "'minimum_tls_version' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_redis_cache", name], []),
		"remediation": "minimum_tls_version = \"1.2\"",
		"remediationType": "addition",
	}
}