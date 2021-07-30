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
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.DBforPostgreSQL/servers/configurations"
	endswith(resource.name, "log_connections")
	resource.properties.value == "off"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.value", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' has 'log_connections' property set to 'on'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' doesn't have 'log_connections' property set to 'on'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.DBforPostgreSQL/servers/configurations"
	endswith(resource.name, "log_connections")
	not common_lib.valid_key(resource.properties, "value")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' has 'log_connections' property set to 'on'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' doesn't have 'log_connections' value undefined",
	}
}
