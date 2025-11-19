package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_managed_disk[name]

	results := undefined_or_empty(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_managed_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": sprintf("'azurerm_managed_disk[%s].encryption_settings' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_managed_disk[%s].encryption_settings' is %s", [name, results.actual_value_string]),
		"searchLine":  results.searchLine,
	}
}

undefined_or_empty(encryption, name) = results {
	not common_lib.valid_key(encryption, "encryption_settings")
	results := {
		"searchKey": sprintf("azurerm_managed_disk[%s]", [name]),
		"issueType": "MissingAttribute",
		"searchLine":  common_lib.build_search_line(["resource", "azurerm_managed_disk", name], []),
		"actual_value_string": "undefined or null"
	}
} else = results {
	encryption.encryption_settings == [[],{}][_] # [] for tfplan support
	results := {
		"searchKey": sprintf("azurerm_managed_disk[%s].encryption_settings", [name]),
		"issueType": "IncorrectValue",
		"searchLine":  common_lib.build_search_line(["resource", "azurerm_managed_disk", name, "encryption_settings"], []),
		"actual_value_string": sprintf("set to '%v'",[encryption.encryption_settings])
	}
}

CxPolicy[result] {															#legacy
	resource := input.document[i].resource.azurerm_managed_disk[name]

	common_lib.valid_key(resource.encryption_settings, "enabled")
	resource.encryption_settings.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_managed_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_managed_disk[%s].encryption_settings.enabled' should be set to true", [name]),
		"keyActualValue": sprintf("'azurerm_managed_disk[%s].encryption_settings.enabled' is set to false", [name]),
		"searchLine":  common_lib.build_search_line(["resource", "azurerm_managed_disk", name, "encryption_settings", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement"
	}
}
