package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	config := input.document[i].resource.azurerm_postgresql_configuration[name]
	config.name == "log_retention_days"

	not commonLib.between(to_number(config.value), 4, 7)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_postgresql_configuration",
		"resourceName": tf_lib.get_resource_name(config, name),
		"searchKey": sprintf("azurerm_postgresql_configuration[%s].value", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_postgresql_configuration[%s].value' is greater than 3 and less than 8", [name]),
		"keyActualValue": sprintf("'azurerm_postgresql_configuration[%s].value' is %s", [name, config.value]),
		"searchLine": commonLib.build_search_line(["resource","azurerm_postgresql_configuration" ,name, "value"], []),
		"remediation": json.marshal({
			"before": sprintf("%d", [config.value]),
			"after": "7"
		}),
		"remediationType": "replacement",
	}
}
