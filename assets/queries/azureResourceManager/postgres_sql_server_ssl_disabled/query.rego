package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.DBforPostgreSQL/servers"
	name := resource.name
	not commonLib.valid_key(resource.properties, "sslEnforcement")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' has 'sslEnforcement' property defined",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' doesn't have 'sslEnforcement' property defined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.DBforPostgreSQL/servers"
	name := resource.name
	lower(resource.properties.sslEnforcement) == "disabled"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name[%s].properties.sslEnforcement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' has 'sslEnforcement' property set to 'Enabled'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers' doesn't have 'sslEnforcement' property set to 'Enabled'",
	}
}
