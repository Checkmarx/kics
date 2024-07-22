package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

CxPolicy[result] {
	doc := input.document[i]
	[parentPath, parentValue] = walk(doc)
	parentValue.type == "Microsoft.DBforPostgreSQL/servers"
	[childPath, childValue] := walk(parentValue)
	childValue.type == "configurations"
	endswith(childValue.name, "log_checkpoints")
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, childValue.properties.value)
	val == "off"

	result := {
		"documentId": input.document[i].id,
		"resourceType": parentValue.type,
		"resourceName": parentValue.name,
		"searchKey": sprintf("%s.name={{%s}}.resources.name=log_checkpoints.properties.value", [common_lib.concat_path(parentPath), parentValue.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' should have 'log_checkpoints' %s set to 'on'", [val_type]),
		"keyActualValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' has 'log_checkpoints' set to 'off'",
		"searchLine": common_lib.build_search_line(parentPath, ["resources", "properties", "value"]),
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
		"resourceType": parentValue.type,
		"resourceName": parentValue.name,
		"searchKey": sprintf("%s.name={{%s}}.resources.name=log_checkpoints", [common_lib.concat_path(parentPath), parentValue.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' should have 'log_checkpoints' set to 'on'",
		"keyActualValue": "child resource with 'configurations' of resource type 'Microsoft.DBforPostgreSQL/servers' 'log_checkpoints' is not defined",
		"searchLine": common_lib.build_search_line(parentPath, ["resources", "name"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.DBforPostgreSQL/servers/configurations"
	endswith(value.name, "log_checkpoints")
	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.value)
	val == "off"

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.value", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' should have 'log_checkpoints' %s set to 'on'", [val_type]),
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' doesn't have 'log_checkpoints' property set to 'off'",
		"searchLine": common_lib.build_search_line(path, ["properties", "value"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)
	value.type == "Microsoft.DBforPostgreSQL/servers/configurations"
	endswith(value.name, "log_checkpoints")
	not common_lib.valid_key(value.properties, "value")

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' should have 'log_checkpoints' property set to 'off'",
		"keyActualValue": "resource with type 'Microsoft.DBforPostgreSQL/servers/configurations' 'log_checkpoints' is not defined",
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}
