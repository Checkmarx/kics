package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource
	encryption := resource.azurerm_managed_disk[name]
	not common_lib.valid_key(encryption, "encryption_settings")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_managed_disk[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_managed_disk[%s].encryption_settings is defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_managed_disk[%s].encryption_settings is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource
	encryption := resource.azurerm_managed_disk[name]
	encryption.encryption_settings.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled is true ", [name]),
		"keyActualValue": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled is false", [name]),
	}
}
