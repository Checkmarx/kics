package Cx

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
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s is slow logs but is not enabled", [name, log]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions.%s is slow logs as is enabled", [name, log]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::Elasticsearch::Domain"
	properties := resource.Properties
	object.get(properties, "LogPublishingOptions", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.LogPublishingOptions", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.LogPublishingOptions exists", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.LogPublishingOptions doe snot exist", [name]),
	}
}

contains(array, elem) {
	array[_] == elem
} else = false {
	true
}
