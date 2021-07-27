package Cx

CxPolicy[result] {
	emailType := ["alertNotifications", "notificationsByRole"]
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.Security/securityContacts"
	object.get(resource.properties, emailType[x], "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.type={{Microsoft.Security/securityContacts}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Security/securityContacts' has '%s.state' property set to 'On'", [emailType[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Security/securityContacts' doesn't have '%s' property defined", [emailType[x]]),
	}
}

CxPolicy[result] {
	emailType := ["alertNotifications", "notificationsByRole"]
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.Security/securityContacts"
	object.get(resource.properties[emailType[x]], "state", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.type={{Microsoft.Security/securityContacts}}.properties.alertNotifications", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Security/securityContacts' has '%s.state' property set to 'On'", [emailType[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Security/securityContacts' doesn't have '%s.state' property defined", [emailType[x]]),
	}
}

CxPolicy[result] {
	emailType := ["alertNotifications", "notificationsByRole"]
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.Security/securityContacts"
	lower(resource.properties[emailType[x]].state) == "off"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.type={{Microsoft.Security/securityContacts}}.properties.alertNotifications.state", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Security/securityContacts' has '%s.state' property set to 'On'", [emailType[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Security/securityContacts' has '%s.state' property set to 'Off'", [emailType[x]]),
	}
}
