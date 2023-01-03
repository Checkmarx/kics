package Cx

import data.generic.common as common_lib
import data.generic.azureresourcemanager as arm_lib

types := {"Microsoft.Network/networkWatchers/flowLogs", "Microsoft.Network/networkWatchers/FlowLogs"}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == types[t]

	fields := {"enabled", "retentionPolicy"}
	not common_lib.valid_key(value.properties, fields[x])

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' should have '%s' property defined", [fields[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have '%s' property defined", [fields[x]]),
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == types[t]

	[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.enabled)
	val == true

	fields := {"enabled", "days"}
	not common_lib.valid_key(value.properties.retentionPolicy, fields[x])

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.retentionPolicy", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' should have '%s' property defined", [fields[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have '%s' property defined", [fields[x]]),
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionPolicy"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == types[t]

	[val, val_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.enabled)
	val == true
	[val_rp, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.retentionPolicy.enabled)
	val_rp == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.retentionPolicy.enabled", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' should have 'enabled' %s set to true", [val_type]),
		"keyActualValue": "resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have 'enabled' set to true",
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionPolicy", "enabled"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == types[t]

	[val, _] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.enabled)
	val == true
	[val_rp, val_rp_type] := arm_lib.getDefaultValueFromParametersIfPresent(doc, value.properties.retentionPolicy.days)
	val_rp <= 90

	result := {
		"documentId": input.document[i].id,
		"resourceType": value.type,
		"resourceName": value.name,
		"searchKey": sprintf("%s.name={{%s}}.properties.retentionPolicy.days", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' should have 'days' %s higher than 90", [val_rp_type]),
		"keyActualValue": "resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have 'days' property higher than 90",
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionPolicy", "days"]),
	}
}
