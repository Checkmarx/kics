package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	storage := document.resource.azurerm_storage_account[name]
	storage.min_tls_version != "TLS1_2"

	result := {
		"documentId": document.id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(storage, name),
		"searchKey": sprintf("azurerm_storage_account[%s].min_tls_version", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_storage_account[%s].min_tls_version' is 'TLS1_2'", [name]),
		"keyActualValue": sprintf("'azurerm_storage_account[%s].min_tls_version' is not 'TLS1_2'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "min_tls_version"], []),
		"remediation": json.marshal({
			"before": sprintf("%s", [storage.min_tls_version]),
			"after": "TLS1_2",
		}),
		"remediationType": "replacement",
	}
}
