package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_databricks_workspace[name]

	results := get_results(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_databricks_workspace",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(databricks, name) = results {
	not common_lib.valid_key(databricks, "customer_managed_key_enabled")

	results := {
		"searchKey" : sprintf("azurerm_databricks_workspace[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue" : sprintf("'azurerm_databricks_workspace[%s].customer_managed_key_enabled' should be defined and set to true", [name]),
		"keyActualValue" : sprintf("'azurerm_databricks_workspace[%s].customer_managed_key_enabled' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name], [])
	}
} else = results {
	databricks.customer_managed_key_enabled != true

	results := {
		"searchKey" : sprintf("azurerm_databricks_workspace[%s].customer_managed_key_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue" : sprintf("'azurerm_databricks_workspace[%s].customer_managed_key_enabled' should be defined and set to true", [name]),
		"keyActualValue" : sprintf("'azurerm_databricks_workspace[%s].customer_managed_key_enabled' is set to %s", [name, databricks.customer_managed_key_enabled]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name, "customer_managed_key_enabled"], [])
	}
} else = results {
	not common_lib.valid_key(databricks, "managed_disk_cmk_key_vault_key_id")

	results := {
		"searchKey" : sprintf("azurerm_databricks_workspace[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue" : sprintf("'azurerm_databricks_workspace[%s].managed_disk_cmk_key_vault_key_id' should be defined and not null", [name]),
		"keyActualValue" : sprintf("'azurerm_databricks_workspace[%s].managed_disk_cmk_key_vault_key_id' is undefined or null", [name]),
		"searchLine" : common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name], [])
	}
}
