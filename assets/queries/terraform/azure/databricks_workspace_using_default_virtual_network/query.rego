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
		"issueType": "MissingAttribute",
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(databricks, name) = results {
	not common_lib.valid_key(databricks, "custom_parameters")

	results := {
		"searchKey": sprintf("azurerm_databricks_workspace[%s]", [name]),
		"keyExpectedValue": sprintf("'azurerm_databricks_workspace[%s].custom_parameters.virtual_network_id' should be defined and not empty", [name]),
		"keyActualValue": sprintf("'azurerm_databricks_workspace[%s].custom_parameters' is undefined or empty", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name], []),
	}

} else = results {
	not common_lib.valid_key(databricks.custom_parameters, "virtual_network_id")

	results := {
		"searchKey": sprintf("azurerm_databricks_workspace[%s].custom_parameters", [name]),
		"keyExpectedValue": sprintf("'azurerm_databricks_workspace[%s].custom_parameters.virtual_network_id' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_databricks_workspace[%s].custom_parameters.virtual_network_id' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name, "custom_parameters"], []),
	}

}
