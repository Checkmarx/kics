package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	not common_lib.valid_key(value.properties, "httpsOnly")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Web/sites' should have the 'httpsOnly' property defined",
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'httpsOnly' property defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Web/sites"
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.httpsOnly)
	val == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.httpsOnly", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Web/sites' should have the 'httpsOnly' %s set to true", [val]),
		"keyActualValue": "resource with type 'Microsoft.Web/sites' doesn't have 'httpsOnly' set to true",
		"searchLine": common_lib.build_search_line(path, ["properties", "httpsOnly"]),
	}
}
