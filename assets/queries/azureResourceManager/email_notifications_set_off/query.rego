package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

emailType := ["alertNotifications", "notificationsByRole"]

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.Security/securityContacts"

	not common_lib.valid_key(value.properties, emailType[x])

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Security/securityContacts' should have '%s.state' property set to 'On'", [emailType[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Security/securityContacts' doesn't have '%s' property defined", [emailType[x]]),
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.Security/securityContacts"

	not common_lib.valid_key(value.properties[emailType[x]], "state")

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.%s", [common_lib.concat_path(path), value.name, emailType[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Security/securityContacts' should have '%s.state' property set to 'On'", [emailType[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Security/securityContacts' doesn't have '%s.state' property defined", [emailType[x]]),
		"searchLine": common_lib.build_search_line(path, ["properties", emailType[x]]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.Security/securityContacts"

	[val, type]:= arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties[emailType[x]].state)
	lower(val) == "off"

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.%s.state", [common_lib.concat_path(path), value.name, emailType[x]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Security/securityContacts' %s should have '%s.state' property set to 'On'", [type ,emailType[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Security/securityContacts' should have '%s.state' property set to 'Off'", [emailType[x]]),
		"searchLine": common_lib.build_search_line(path, ["properties", emailType[x], "state"]),
	}
}
