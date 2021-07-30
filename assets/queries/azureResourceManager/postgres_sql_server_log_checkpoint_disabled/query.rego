package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	doc := input.document[i]
	[parentPath, parentValue] = walk(doc)
	parentValue.type == "Microsoft.DBforPostgreSQL/servers"
	[childPath, childValue] := walk(parentValue)
	childValue.type == "configurations"
	endswith(childValue.name, "log_checkpoints")
	childValue.properties.value == "off"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.resources.name=log_checkpoints.properties.value", [common_lib.concat_path(parentPath), parentValue.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_checkpoints' set to 'on'",
		"keyActualValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_checkpoints' set to 'off'",
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[parentPath, parentValue] = walk(doc)
	parentValue.type == "Microsoft.DBforPostgreSQL/servers"
	[childPath, childValue] := walk(parentValue)
	childValue.type == "configurations"
	childValue.name == "log_checkpoints"
	not common_lib.valid_key(childValue.properties, "value")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.name=log_checkpoints", [common_lib.concat_path(parentPath), parentValue.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_checkpoints' set to 'on'",
		"keyActualValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' 'log_checkpoints' is not defined",
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
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' has 'log_checkpoints' property set to 'on'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' doesn't have 'log_checkpoints' property set to 'off'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.DBforPostgreSQL/servers/configurations"
	endswith(resource.name, "log_checkpoints")
	not common_lib.valid_key(resource.properties, "value")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' has 'log_checkpoints' property set to 'off'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' 'log_checkpoints' is not defined",
	}
}
