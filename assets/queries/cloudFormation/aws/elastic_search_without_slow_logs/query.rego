package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

slowLogs := ["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS"]

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	common_lib.valid_key(resource.Properties, "LogPublishingOptions")
	logs := [logName | contains(slowLogs, logName); log := resource.Properties.LogPublishingOptions[logName]]
	count(logs) == 0

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LogPublishingOptions", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions declares slow logs", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions does not declares slow logs", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "LogPublishingOptions"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	logs := resource.Properties.LogPublishingOptions[logName]
	logName == slowLogs[j]
	logs.Enabled == "false"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.LogPublishingOptions.%s.Enabled", [name, logName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s is a slow log and is enabled", [name, logName]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s is a slow log but isn't enabled", [name, logName]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "LogPublishingOptions", logName, "Enabled"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	properties := resource.Properties
	not common_lib.valid_key(properties, "LogPublishingOptions")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions is defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties"], []),
	}
}

contains(array, elem) {
	array[_] == elem
} else = false {
	true
}
