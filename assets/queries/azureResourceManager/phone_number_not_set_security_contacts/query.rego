package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.Security/securityContacts"
	not commonLib.valid_key(resource.properties, "phone")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Security/securityContacts}}.properties",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Security/securityContacts' has 'phone' property defined",
		"keyActualValue": "resource with type 'Microsoft.Security/securityContacts' doesn't have 'phone' property defined",
	}
}
