package Cx

import data.generic.common as common_lib

types := {"Microsoft.Network/networkWatchers/flowLogs", "Microsoft.Network/networkWatchers/FlowLogs"}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == types[t]

	fields := {"enabled", "retentionPolicy"}
	not common_lib.valid_key(value.properties, fields[x])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' has '%s' property defined", [fields[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have '%s' property defined", [fields[x]]),
		"searchLine": common_lib.build_search_line(path, ["properties"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == types[t]

	value.properties.enabled == true

	fields := {"enabled", "days"}
	not common_lib.valid_key(value.properties.retentionPolicy, fields[x])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties.retentionPolicy", [common_lib.concat_path(path), value.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' has '%s' property defined", [fields[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have '%s' property defined", [fields[x]]),
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionPolicy"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == types[t]

	value.properties.enabled == true
	value.properties.retentionPolicy.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties.retentionPolicy.enabled", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Network/networkWatchers/FlowLogs' has 'enabled' property set to true",
		"keyActualValue": "resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have 'enabled' set to true",
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionPolicy", "enabled"]),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	[path, value] = walk(doc)

	value.type == types[t]

	value.properties.enabled == true
	value.properties.retentionPolicy.days <= 90

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s.name={{%s}}.properties.retentionPolicy.days", [common_lib.concat_path(path), value.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Network/networkWatchers/FlowLogs' has 'days' property higher than 90",
		"keyActualValue": "resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have 'days' property higher than 90",
		"searchLine": common_lib.build_search_line(path, ["properties", "retentionPolicy", "days"]),
	}
}
