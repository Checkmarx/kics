package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[var0]
	not common_lib.valid_key(resource, "https_traffic_only_enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, var0),
		"searchKey": sprintf("azurerm_storage_account[%s]", [var0]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_storage_account.%s.https_traffic_only_enabled ' equals 'true'", [var0]),
		"keyActualValue": sprintf("'azurerm_storage_account.%s.https_traffic_only_enabled ' does not exist", [var0]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_storage_account" ,var0, "https_traffic_only_enabled"], []),
		"remediation": "https_traffic_only_enabled = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[var0]
	resource.https_traffic_only_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(resource, var0),
		"searchKey": sprintf("azurerm_storage_account[%s].https_traffic_only_enabled", [var0]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_storage_account.%s.https_traffic_only_enabled' equals 'true'", [var0]),
		"keyActualValue": sprintf("'azurerm_storage_account.%s.https_traffic_only_enabled' equals 'false'", [var0]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_storage_account" ,var0, "https_traffic_only_enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
