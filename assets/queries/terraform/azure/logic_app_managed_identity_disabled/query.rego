package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
    logic_app := input.document[i].resource.azurerm_logic_app_standard[name]

    not common_lib.valid_key(logic_app, "identity")

    result := {
        "documentId": input.document[i].id,
		"resourceType": "azurerm_logic_app_standard",
		"resourceName": tf_lib.get_resource_name(logic_app, name),
		"searchKey": sprintf("azurerm_logic_app_standard[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'type' field should have the values 'SystemAssigned' or 'UserAssigned' defined inside the 'identity' block",
		"keyActualValue": "'identity' block is not defined",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_logic_app_standard", name], []),
        "remediationType": "addition",
        "remediation": "identity {\n\t\ttype = \"SystemAssigned, UserAssigned\"\n\t}",
    }
}