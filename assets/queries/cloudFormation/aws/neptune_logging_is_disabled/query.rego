package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Neptune::DBCluster"

	results := is_null_or_missing_LogsExports(resource.Properties,path,name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": sprintf("'Resources.%s.Properties' should have 'EnableCloudwatchLogsExports' enabled ", [name]),
		"keyActualValue": results.keyActualValue,
        "searchLine": results.searchLine,
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Neptune::DBCluster"

    common_lib.valid_key(resource.Properties,"EnableCloudwatchLogsExports")
	not common_lib.inArray(resource.Properties.EnableCloudwatchLogsExports,"audit")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.EnableCloudwatchLogsExports", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.EnableCloudwatchLogsExports' should include 'audit'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.EnableCloudwatchLogsExports' does not include 'audit'", [name]),
        "searchLine": common_lib.build_search_line(path, [name, "Properties", "EnableCloudwatchLogsExports"]),
	}
}

is_null_or_missing_LogsExports(Properties,path,name) = results {
	Properties.EnableCloudwatchLogsExports == null
	results := {
		"searchKey" : sprintf("%s%s.Properties.EnableCloudwatchLogsExports", [cf_lib.getPath(path), name]),
		"issueType" : "IncorrectValue",
		"keyActualValue": sprintf("'Resources.%s.Properties.EnableCloudwatchLogsExports' is set to null", [name]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties","EnableCloudwatchLogsExports"])
	}
} else = results {
	not common_lib.valid_key(Properties,"EnableCloudwatchLogsExports")
	results := {
		"searchKey" : sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType" : "MissingAttribute",
		"keyActualValue": sprintf("'Resources.%s.Properties.EnableCloudwatchLogsExports' is undefined", [name]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties"])
	}
}
