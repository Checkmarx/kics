package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

resource_types := {"azurerm_app_service_slot", "azurerm_linux_web_app_slot", "azurerm_windows_web_app_slot"}

CxPolicy[result] {
    app_service_slot := input.document[i].resource[resource_types[idx_type]][name]

    not common_lib.valid_key(app_service_slot, "identity")

    result := {
        "documentId": input.document[i].id,
		"resourceType": resource_types[idx_type],
		"resourceName": tf_lib.get_resource_name(app_service_slot, name),
		"searchKey": sprintf("%s[%s]", [resource_types[idx_type], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'type' field should have the values 'SystemAssigned' or 'UserAssigned' defined inside the 'identity' block",
		"keyActualValue": "'identity' block is not defined",
		"searchLine": common_lib.build_search_line(["resource", resource_types[idx_type], name], []),
        "remediationType": "addition",
        "remediation": "identity {\n\t\ttype = \"SystemAssigned, UserAssigned\"\n\t}",
    }
}