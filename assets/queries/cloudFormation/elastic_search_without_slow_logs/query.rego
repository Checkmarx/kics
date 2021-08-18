package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	logs := resource.Properties.LogPublishingOptions[log]
	not contains(["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS"], log)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LogPublishingOptions.%s", [name, log]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s is slow logs", [name, log]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s is not not slow logs", [name, log]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	logs := resource.Properties.LogPublishingOptions[log]
	contains(["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS"], log)
	logs.Enabled == "false"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LogPublishingOptions.%s.Enabled", [name, log]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s is a slow log and is enabled", [name, logs]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s is a slow log but isn't enabled", [name, logs]),
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
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions is defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions is undefined or null", [name]),
	}
}

contains(array, elem) {
	array[_] == elem
} else = false {
	true
}
