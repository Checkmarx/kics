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
		"searchKey": sprintf("resources.type={{%s}}.properties", [types[t]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' has '%s' property defined", [fields[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have '%s' property defined", [fields[x]]),
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
		"searchKey": sprintf("resources.type={{%s}}.properties.retentionPolicy", [types[t]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' has '%s' property defined", [fields[x]]),
		"keyActualValue": sprintf("resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have '%s' property defined", [fields[x]]),
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
		"searchKey": sprintf("resources.type={{%s}}.properties.retentionPolicy.enabled", [types[t]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Network/networkWatchers/FlowLogs' has 'enabled' property set to true",
		"keyActualValue": "resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have 'enabled' set to true",
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
		"searchKey": sprintf("resources.type={{%s}}.properties.retentionPolicy.days", [types[t]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "resource with type 'Microsoft.Network/networkWatchers/FlowLogs' has 'days' property higher than 90",
		"keyActualValue": "resource with type 'Microsoft.Network/networkWatchers/FlowLogs' doesn't have 'days' property higher than 90",
	}
}
