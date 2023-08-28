package Cx

import data.generic.common as common_lib
import data.generic.crossplane as cp_lib

validTypes := {"profiler", "audit"}

validTypeConcat := concat(", ", validTypes)

CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	resource.kind == "DBCluster"
	spec = resource.spec

	not common_lib.valid_key(spec.forProvider, "enableCloudwatchLogsExports")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "DBCluster",
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider", [cp_lib.getPath(path), resource.metadata.name]),
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider"]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "DBCluster.enableCloudwatchLogsExports should be defined",
		"keyActualValue": "DBCluster.enableCloudwatchLogsExports is undefined",
	}
}


CxPolicy[result] {
	docs := input.document[i]
	[path, resource] := walk(docs)
	resource.kind == "DBCluster"
	
	spec := resource.spec
	provider := spec.forProvider
	logs := provider.enableCloudwatchLogsExports

	logsSet := {log | log := logs[_]}
	missingTypes := validTypes - logsSet

	count(missingTypes) > 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": "DBCluster",
		"resourceName": resource.metadata.name,
		"searchKey": sprintf("%smetadata.name={{%s}}.spec.forProvider.enableCloudwatchLogsExports", [cp_lib.getPath(path), resource.metadata.name]),
		"searchLine": common_lib.build_search_line(path, ["spec", "forProvider","enableCloudwatchLogsExports"]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("DBCluster.enableCloudwatchLogsExports should have all following values: %s", [validTypeConcat]),
		"keyActualValue": sprintf("DBCluster.enableCloudwatchLogsExports has the following missing values: %s", [concat(", ", missingTypes)]),
	}
}
