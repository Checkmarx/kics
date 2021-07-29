package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	doc := input.document[i]
	[parentPath, parentValue] = walk(doc)
	parentValue.type = "Microsoft.DBforPostgreSQL/servers"
	[childPath, childValue] := walk(parentValue)
	childValue.type == "configurations"
	childValue.name == "log_checkpoints"
	childValue.properties.value == "off"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.%s", [commonLib.concat_path(parentPath), commonLib.concat_path(childPath)]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_checkpoints' set to 'off'",
		"keyActualValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_checkpoints' set to 'on'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[_]
	resource.type == "Microsoft.DBforPostgreSQL/servers/configurations"
	resource.name == "log_checkpoints"
	resource.properties.value == "off"

	result := {
		"documentId": input.document[i].id,
		"searchKey": "resources.name[log_checkpoints].properties.value",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' has 'log_checkpoints' property set to 'off'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' doesn't have 'log_checkpoints' property set to 'on'",
	}
}

configurationResourceTypes := {"configurations", "Microsoft.DBforPostgreSQL/servers/configurations"}

CxPolicy[result] {
	doc := input.document[i]
	[parentPath, parentValue] = walk(doc)
	parentValue.type = "Microsoft.DBforPostgreSQL/servers"
	configResType := configurationResourceTypes[k]
	count([x |
		parentValue.resources[j].type == configResType
		parentValue.resources[j].name == "log_checkpoints"
		x := parentValue.resources[j]
	]) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.%s", [commonLib.concat_path(parentPath), "resources"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type '%s' defines the 'log_checkpoints' property", configResType),
		"keyActualValue": sprintf("resource with type '%s' does not define the 'log_checkpoints' property", configResType),
	}
}
