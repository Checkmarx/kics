package Cx

import data.generic.common as common_lib

validTypes := {"profiler", "audit"}

validTypeConcat := concat(", ", validTypes)

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:docdb:Cluster"
	properties := resource.properties
	not common_lib.valid_key(properties, "enabledCloudwatchLogsExports")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": name,
		"searchKey": sprintf("resources[%s].properties", [name]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties"],[]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws:docdb:Cluster.enabledCloudwatchLogsExports should be defined",
		"keyActualValue": "aws:docdb:Cluster.enabledCloudwatchLogsExports is undefined",
	}
}


CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:docdb:Cluster"
	properties := resource.properties
	logs := properties.enabledCloudwatchLogsExports

	logsSet := {log | log := logs[_]}
	missingTypes := validTypes - logsSet

	count(missingTypes) > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": name,
		"searchKey": sprintf("resources[%s].properties.enabledCloudwatchLogsExports", [name]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "enabledCloudwatchLogsExports"],[]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws:docdb:Cluster.enabledCloudwatchLogsExports should have all following values: %s", [validTypeConcat]),
		"keyActualValue": sprintf("aws:docdb:Cluster.enabledCloudwatchLogsExports has the following missing values: %s", [concat(", ", missingTypes)]),
	}
}
