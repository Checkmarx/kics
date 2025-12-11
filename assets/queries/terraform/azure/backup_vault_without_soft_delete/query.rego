package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_data_protection_backup_vault[name]

	resource.soft_delete == "off"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_data_protection_backup_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_data_protection_backup_vault[%s].soft_delete", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_data_protection_backup_vault[%s].soft_delete' should not be set to 'off'", [name]),
		"keyActualValue": sprintf("'azurerm_data_protection_backup_vault[%s].soft_delete' is set to 'off'", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_data_protection_backup_vault", name, "soft_delete"], [])
	}
}
