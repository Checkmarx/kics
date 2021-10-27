package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[parentPath, parentValue] = walk(doc)
	parentValue.type == "Microsoft.DBforPostgreSQL/servers"
	parentName := parentValue.name
	[childPath, childValue] := walk(parentValue)
	childValue.type == "configurations"
	childValue.name == "log_connections"
	childValue.properties.value == "off"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.resources.name=log_connections.properties.value", [common_lib.concat_path(parentPath), parentName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_connections' set to 'on'",
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
		"searchKey": sprintf("%s.name={{%s}}.resources.name=log_connections", [common_lib.concat_path(parentPath), parentName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_connections' set to 'on'",
		"keyActualValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_connections' value undefined",
		"searchLine": common_lib.build_search_line(parentPath, ["resources", "name"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.DBforPostgreSQL/servers/configurations"
	endswith(value.name, "log_connections")
	value.properties.value == "off"

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("%s.name={{%s}}.properties.value", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' has 'log_connections' property set to 'on'",
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
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' has 'log_connections' property set to 'on'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' doesn't have 'log_connections' value undefined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}
