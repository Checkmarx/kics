package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_recovery_services_vault[name]

	resource.soft_delete_enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_recovery_services_vault",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_recovery_services_vault[%s].soft_delete_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_recovery_services_vault[%s].soft_delete_enabled' should not be set to false", [name]),
		"keyActualValue": sprintf("'azurerm_recovery_services_vault[%s].soft_delete_enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_recovery_services_vault", name, "soft_delete_enabled"], [])
	}
}
