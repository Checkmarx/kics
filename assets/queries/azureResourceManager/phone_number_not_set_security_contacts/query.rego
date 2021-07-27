package Cx

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.Security/securityContacts"
	object.get(resource.properties, "phone", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Security/securityContacts}}.properties",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Security/securityContacts' has 'phone' property defined",
		"keyActualValue": "resource with type 'Microsoft.Security/securityContacts' doesn't have 'phone' property defined",
	}
}
