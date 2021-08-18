package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.properties, "siteConfig")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Web/sites}}.properties",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the 'siteConfig' property defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'siteConfig' property defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.properties.siteConfig, "http20Enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Web/sites}}.properties",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the 'http20Enabled' property defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'http20Enabled' property defined",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	value.properties.siteConfig.http20Enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.type={{Microsoft.Web/sites}}.properties.siteConfig.http20Enabled",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' has the 'http20Enabled' property set to true",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'http20Enabled' set to true",
	}
}
