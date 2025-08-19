package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

types := ["AWS::Elasticsearch::Domain","AWS::OpenSearchService::Domain"]
slowLogs := ["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS"]

CxPolicy[result] {
	#Case of no "LogPublishingOptions" field
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == types[_]
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
		"searchLine": common_lib.build_search_line(path, [name, "Properties"]),
	}
}

CxPolicy[result] {
	#Case of no log specification for INDEX_SLOW_LOGS/SEARCH_SLOW_LOGS witin LogPublishingOptions
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == types[_]
	common_lib.valid_key(resource.Properties, "LogPublishingOptions")
	logs := [logName | logName == slowLogs[_] ; log := resource.Properties.LogPublishingOptions[logName]]
	count(logs) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s%s.Properties.LogPublishingOptions", [cf_lib.getPath(path),name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions should declare slow logs", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions does not declare slow logs", [name]),
		"searchLine": common_lib.build_search_line(path, [name, "Properties", "LogPublishingOptions"]),
	}
}

CxPolicy[result] {
	#Case of "Enabled" field undefined or set to false within the log specification
	docs := input.document[i]
	[path, Resources] := walk(docs)
	resource := Resources[name]
	resource.Type == types[_]
	logs := resource.Properties.LogPublishingOptions[logName]
	logName == slowLogs[_]
	results := cf_lib.enabled_is_undefined_or_false(logs,path,name,logName)
	results != ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s.Enabled should be defined and set to 'true'", [name, logName]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s.Enabled %s", [name, logName, results.print]),
		"searchLine": results.searchLine,
	}
}