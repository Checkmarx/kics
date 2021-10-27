package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"
	resourceName := value.name

	to_number(split(value.apiVersion, "-")[0]) < 2019

	pathValue := is_undefined(value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}%s", [resourceName, pathValue.sk]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' has the 'supportsHttpsTrafficOnly' property defined",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' doesn't have 'supportsHttpsTrafficOnly' property defined",
		"searchLine": common_lib.build_search_line(path, pathValue.sl),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"
	to_number(split(value.apiVersion, "-")[0]) >= 2019

	value.properties.supportsHttpsTrafficOnly == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name=%s.properties.supportsHttpsTrafficOnly", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' has the 'supportsHttpsTrafficOnly' property set to true",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' doesn't have 'supportsHttpsTrafficOnly' set to true",
		"searchLine": common_lib.build_search_line(path, ["properties", "supportsHttpsTrafficOnly"]),
	}
}

is_undefined(value) = path {
	not common_lib.valid_key(value, "properties")
	path := {"sk": "", "sl": ["name"]}
} else = path {
	not common_lib.valid_key(value.properties, "supportsHttpsTrafficOnly")
	path := {"sk": "properties", "sl": ["properties"]}
}
