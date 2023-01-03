package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource
	encryption := resource.azurerm_managed_disk[name]
	not common_lib.valid_key(encryption, "encryption_settings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_managed_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_managed_disk[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("azurerm_managed_disk[%s].encryption_settings should be defined and not null", [name]),
		"keyActualValue": sprintf("azurerm_managed_disk[%s].encryption_settings is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_managed_disk" ,name], []),
		"remediation": "encryption_settings = {\n\t\t enabled= true\n\t}\n",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource
	encryption := resource.azurerm_managed_disk[name]
	encryption.encryption_settings.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_managed_disk",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled should be true ", [name]),
		"keyActualValue": sprintf("azurerm_managed_disk[%s].encryption_settings.enabled is false", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_managed_disk" ,name ,"encryption_settings", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
