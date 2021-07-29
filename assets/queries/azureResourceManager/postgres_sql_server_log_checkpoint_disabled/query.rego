package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[parentPath, parentValue] = walk(doc)
	parentValue.type = "Microsoft.DBforPostgreSQL/servers"
	parentName := parentValue.name
	[childPath, childValue] := walk(parentValue)
	childValue.type == "configurations"
	endswith(childValue.name, "log_checkpoints")
	childValue.properties.value == "off"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.%s.name=log_checkpoints.properties.value", [common_lib.concat_path(parentPath), parentName, common_lib.concat_path(childPath)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_checkpoints' set to 'off'",
		"keyActualValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_checkpoints' set to 'on'",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[parentPath, parentValue] = walk(doc)
	parentValue.type = "Microsoft.DBforPostgreSQL/servers"
	parentName := parentValue.name
	[childPath, childValue] := walk(parentValue)
	childValue.type == "configurations"
	not endswith(childValue.name, "log_checkpoints")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.%s.name=%s", [common_lib.concat_path(parentPath), parentName, common_lib.concat_path(childPath), childValue.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_checkpoints' set to 'off'",
		"keyActualValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_checkpoints' set to 'on'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.DBforPostgreSQL/servers/configurations"
	endswith(resource.name, "log_checkpoints")
	resource.properties.value == "off"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.value", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' has 'log_checkpoints' property set to 'off'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' doesn't have 'log_checkpoints' property set to 'on'",
	}
}
