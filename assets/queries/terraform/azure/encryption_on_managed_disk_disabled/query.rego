package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource
	encryption := resource.azurerm_managed_disk[name]
	results := undefined_or_empty(encryption)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_managed_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey, #sprintf("azurerm_managed_disk[%s]", [name]),
		"issueType": results.issueType, #"MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_managed_disk[%s].encryption_settings should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_managed_disk[%s].encryption_settings is undefined or null", [name]),
		"searchLine":  results.searchLine, #common_lib.build_search_line(["resource","azurerm_managed_disk" ,name], [])
	}
}

undefined_or_empty(encryption) {
	not common_lib.valid_key(encryption, "encryption_settings")
} else {
	encryption.encryption_settings == [[],{}][_] # [] for tfplan support
}

CxPolicy[result] {
	resource := input.document[i].resource
	encryption := resource.azurerm_managed_disk[name]
	common_lib.valid_key(encryption.encryption_settings, "enabled") #legacy
	encryption.encryption_settings.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_managed_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled should be true ", [name]),
		"keyActualValue": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled is false", [name])
	}
}
