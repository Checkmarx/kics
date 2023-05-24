package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

LogTypes := ["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS", "ES_APPLICATION_LOGS", "AUDIT_LOGS"]

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	common_lib.valid_key(resource.Properties, "LogPublishingOptions")
	logs := [logName | contains(LogTypes, logName); log := resource.Properties.LogPublishingOptions[logName]]
	count(logs) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.LogPublishingOptions", [cf_lib.getPath(path),name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions should declare logs", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions does not declares logs", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "LogPublishingOptions"], []),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	logs := resource.Properties.LogPublishingOptions[logName]
	logName == LogTypes[j]
	logs.Enabled == "false"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.LogPublishingOptions.%s.Enabled", [cf_lib.getPath(path),name, logName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s should be enabled if is a log", [name, logName]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s is a log but isn't enabled", [name, logName]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "LogPublishingOptions", logName, "Enabled"], []),
	}
}

CxPolicy[result] {
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	properties := resource.Properties
	not common_lib.valid_key(properties, "LogPublishingOptions")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s%s.Properties.LogPublishingOptions should be defined and not null", [cf_lib.getPath(path),name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties"], []),
	}
}

contains(array, elem) {
	array[_] == elem
} else = false {
	true
}
