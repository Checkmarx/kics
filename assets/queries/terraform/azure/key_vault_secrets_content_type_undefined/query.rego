package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	key := input.document[i].resource.azurerm_key_vault_secret[name]

	not common_lib.valid_key(key, "content_type")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_key_vault_secret",
		"resourceName": tf_lib.get_resource_name(key, name),
		"searchKey": sprintf("azurerm_key_vault_secret[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_key_vault_secret[%s].content_type' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_key_vault_secret[%s].content_type' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault_secret", name], []),
	}
}
