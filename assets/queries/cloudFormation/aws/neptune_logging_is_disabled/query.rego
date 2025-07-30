package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Neptune::DBCluster"
	
    not common_lib.valid_key(resource.Properties,"EnableCloudwatchLogsExports")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties' should have 'EnableCloudwatchLogsExports' enabled ", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties' does not define 'EnableCloudwatchLogsExports' or is set to null", [name]),
        "searchLine": common_lib.build_search_line(path, [name, "Properties"]),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Neptune::DBCluster"
	
    common_lib.valid_key(resource.Properties,"EnableCloudwatchLogsExports")
    not contains_valid_keyword(resource.Properties.EnableCloudwatchLogsExports)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.EnableCloudwatchLogsExports", [cf_lib.getPath(path), name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.EnableCloudwatchLogsExports' should include 'audit' and/or 'slowquery'", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.EnableCloudwatchLogsExports' does not include 'audit' or 'slowquery'", [name]),
        "searchLine": common_lib.build_search_line(path, [name, "Properties", "EnableCloudwatchLogsExports"]),
	}
}


contains_valid_keyword(list) = true {
  list[_] == "audit"
} else = true {
  list[_] == "slowquery"
} else = false
