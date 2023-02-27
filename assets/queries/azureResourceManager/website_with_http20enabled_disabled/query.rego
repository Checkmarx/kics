package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.properties, "siteConfig")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' should have the 'siteConfig' property defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'siteConfig' property defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.properties.siteConfig, "http20Enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.siteConfig", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' should have the 'http20Enabled' property defined in siteConfig",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'http20Enabled' property defined in siteConfig",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.siteConfig.http20Enabled)
	val == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.siteConfig.http20Enabled", [common_lib.concat_path(path), value.name]),
		"searchKey": "resources.type={{Microsoft.Web/sites}}.properties.siteConfig.http20Enabled",
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Web/sites' should have the 'http20Enabled' %s set to true in siteConfig", [val_type]),
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'http20Enabled' set to true in siteConfig",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}
