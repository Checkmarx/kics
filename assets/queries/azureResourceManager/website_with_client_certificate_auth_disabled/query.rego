package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.properties, "clientCertEnabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Web/sites}}.properties",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the 'clientCertEnabled' property defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'clientCertEnabled' property defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	value.properties.clientCertEnabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Web/sites}}.properties.clientCertEnabled",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the 'clientCertEnabled' property set to true",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'clientCertEnabled' set to true",
	}
}
