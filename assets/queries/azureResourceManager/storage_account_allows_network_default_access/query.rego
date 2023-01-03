package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"
	resourceName := value.name

	to_number(split(value.apiVersion, "-")[0]) < 2017

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.apiVersion=%s", [common_lib.concat_path(path), value.name, value.apiVersion]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' apiVersion should be newer than 2017 and enable setting networkAcls",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' apiVersion is older than 2017 and doesn't enable setting networkAcls",
		"searchLine": common_lib.build_search_line(path, ["apiVersion"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"
	to_number(split(value.apiVersion, "-")[0]) >= 2017

	pathValue := is_network_acl_undefined(value)

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s%s", [common_lib.concat_path(path), value.name, pathValue.sk]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.Storage/storageAccounts' should have the 'properties.networkAcls.defaultAction' defined",
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' doesn't have 'properties.networkAcls.defaultAction' defined",
		"searchLine": common_lib.build_search_line(path, pathValue.sl),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == "Microsoft.Storage/storageAccounts"
	to_number(split(value.apiVersion, "-")[0]) >= 2017

	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.networkAcls.defaultAction)
	lower(val) == "allow"

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name=%s.properties.networkAcls.defaultAction", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Storage/storageAccounts' %s should have the 'properties.networkAcls.defaultAction' set to 'Deny'", [val_type]),
		"keyActualValue": "resource with type 'Microsoft.Storage/storageAccounts' has the 'properties.networkAcls.defaultAction' set to 'Allow'",
		"searchLine": common_lib.build_search_line(path, ["properties", "networkAcls", "defaultAction"]),
	}
}

is_network_acl_undefined(value) = path {
	not common_lib.valid_key(value.properties.networkAcls, "defaultAction")
	path := {"sk": ".properties.networkAcls", "sl": ["properties", "networkAcls"]}
} else = path {
	not common_lib.valid_key(value.properties, "networkAcls")
	path := {"sk": ".properties", "sl": ["properties"]}
} else = path {
	not common_lib.valid_key(value, "properties")
	path := {"sk": "", "sl": ["name"]}
}
