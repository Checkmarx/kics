package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_machine_learning_workspace[name]
	not common_lib.valid_key(resource, "encryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_machine_learning_workspace",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_machine_learning_workspace[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_machine_learning_workspace[%s].encryption' should be defined with a customer-managed key", [name]),
		"keyActualValue": sprintf("'azurerm_machine_learning_workspace[%s].encryption' is not defined; using Microsoft-managed key", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_machine_learning_workspace", name], []),
		"remediation": "encryption {\n    key_vault_id = azurerm_key_vault.example.id\n    key_id       = azurerm_key_vault_key.example.id\n  }",
		"remediationType": "addition",
	}
}
