package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[parentPath, parentValue] = walk(doc)
	parentValue.type == "Microsoft.DBforPostgreSQL/servers"
	parentName := parentValue.name
	[childPath, childValue] := walk(parentValue)
	childValue.type == "configurations"
	childValue.name == "log_connections"
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, childValue.properties.value)
	val == "off"

	result := {
		"documentId": input.document[i].id,
		"resourceType": parentValue.type,
		"resourceName": parentName,
		"searchKey": sprintf("%s.name={{%s}}.resources.name=log_connections.properties.value", [common_lib.concat_path(parentPath), parentName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' should have 'log_connections' %s set to 'on'", [val_type]),
		"keyActualValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_connections' set to 'off'",
		"searchLine": common_lib.build_search_line(parentPath, ["resources", "properties", "value"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[parentPath, parentValue] = walk(doc)
	parentValue.type == "Microsoft.DBforPostgreSQL/servers"
	parentName := parentValue.name
	[childPath, childValue] := walk(parentValue)
	childValue.type == "configurations"
	childValue.name == "log_connections"
	not common_lib.valid_key(childValue.properties, "value")

	result := {
		"documentId": input.document[i].id,
		"resourceType": parentValue.type,
		"resourceName": parentName,
		"searchKey": sprintf("%s.name={{%s}}.resources.name=log_connections", [common_lib.concat_path(parentPath), parentName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' should have 'log_connections' set to 'on'",
		"keyActualValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_connections' value undefined",
		"searchLine": common_lib.build_search_line(parentPath, ["resources", "name"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.DBforPostgreSQL/servers/configurations"
	endswith(value.name, "log_connections")
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.value)
	val == "off"

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.value", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' should have 'log_connections' %s set to 'on'", [val_type]),
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' doesn't have 'log_connections' property set to 'on'",
		"searchLine": common_lib.build_search_line(path, ["properties", "value"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.DBforPostgreSQL/servers/configurations"
	endswith(value.name, "log_connections")
	not common_lib.valid_key(value.properties, "value")

	result := {
		"documentId": doc.id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' should have 'log_connections' property set to 'on'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' doesn't have 'log_connections' value undefined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}
