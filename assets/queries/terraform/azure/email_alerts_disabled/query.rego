package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_security_center_contact[name]

	resource.alert_notifications == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_security_center_contact",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_security_center_contact[%s].alert_notifications", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_security_center_contact.%s.alert_notifications' should be true", [name]),
		"keyActualValue": sprintf("'azurerm_security_center_contact.%s.alert_notifications' is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_security_center_contact", name, "alert_notifications"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
