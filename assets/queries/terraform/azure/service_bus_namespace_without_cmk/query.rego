package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_servicebus_namespace[name]
	not common_lib.valid_key(resource, "customer_managed_key")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_servicebus_namespace",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_servicebus_namespace[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_servicebus_namespace[%s].customer_managed_key' should be defined", [name]),
		"keyActualValue": sprintf("'azurerm_servicebus_namespace[%s].customer_managed_key' is not defined; using Microsoft-managed key", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_servicebus_namespace", name], []),
		"remediation": "customer_managed_key {\n    key_vault_key_id                  = azurerm_key_vault_key.example.id\n    identity_id                       = azurerm_user_assigned_identity.example.id\n  }",
		"remediationType": "addition",
	}
}
