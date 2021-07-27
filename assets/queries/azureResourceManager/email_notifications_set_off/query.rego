package Cx

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.Security/securityContacts"
	object.get(resource.properties, "alertNotifications", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.type={{Microsoft.Security/securityContacts}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Security/securityContacts' has 'alertNotifications.state' property set to 'On'",
		"keyActualValue": "resource with type 'Microsoft.Security/securityContacts' doesn't have 'alertNotifications' property defined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.Security/securityContacts"
	object.get(resource.properties.alertNotifications, "state", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.type={{Microsoft.Security/securityContacts}}.properties.alertNotifications", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Security/securityContacts' has 'alertNotifications.state' property set to 'On'",
		"keyActualValue": "resource with type 'Microsoft.Security/securityContacts' doesn't have 'alertNotifications.state' property defined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.Security/securityContacts"
	lower(resource.properties.alertNotifications.state) == "off"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.type={{Microsoft.Security/securityContacts}}.properties.alertNotifications.state", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Security/securityContacts' has 'alertNotifications' property set to 'On'",
		"keyActualValue": "resource with type 'Microsoft.Security/securityContacts' has 'alertNotifications' property set to 'Off'",
	}
}
