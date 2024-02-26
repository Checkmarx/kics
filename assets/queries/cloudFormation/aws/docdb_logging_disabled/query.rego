package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib

validTypes := {"profiler", "audit"}

validTypeConcat := concat(", ", validTypes)

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DocDB::DBCluster"
	properties := resource.Properties

	not common_lib.valid_key(properties, "EnableCloudwatchLogsExports")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "AWS::DocDB::DBCluster",
		"resourceName": key,
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"searchLine": common_lib.build_search_line(["Resources", key, "Properties"], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "AWS::DocDB::DBCluster.Properties.EnableCloudwatchLogsExports should be defined",
		"keyActualValue": "AWS::DocDB::DBCluster.Properties.EnableCloudwatchLogsExports is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DocDB::DBCluster"
	properties := resource.Properties
	logs := properties.EnableCloudwatchLogsExports
	
	logsSet := {log | log := logs[_]}
	missingTypes := validTypes - logsSet

	count(missingTypes) > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "AWS::DocDB::DBCluster",
		"resourceName": key,
		"searchKey": sprintf("Resources.%s.Properties.EnableCloudwatchLogsExports", [key]),
		"searchLine": common_lib.build_search_line(["Resources", key, "Properties", "EnableCloudwatchLogsExports"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("AWS::DocDB::DBCluster.Properties.EnableCloudwatchLogsExports should have all following values: %s", [validTypeConcat]),
		"keyActualValue": sprintf("AWS::DocDB::DBCluster.Properties.EnableCloudwatchLogsExports haven't got the following values: %s", [concat(", ", missingTypes)]),
	}
}