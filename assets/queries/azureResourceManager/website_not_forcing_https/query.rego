package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not commonLib.valid_key(value.properties, "httpsOnly")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Web/sites}}.properties",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the 'httpsOnly' property defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'httpsOnly' property defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	value.properties.httpsOnly == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Web/sites}}.properties.httpsOnly",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the 'httpsOnly' property set to true",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'httpsOnly' set to true",
	}
}
