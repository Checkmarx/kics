package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	defaultsGroup := input.document[i].groups.defaults

    not common_lib.valid_key(defaultsGroup, "no_log")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "defaults",
		"issueType": "IncorrectValue",
		"resourceType": "n/a",
		"resourceName": "n/a",
		"keyExpectedValue": "no_log should be defined and set to 'true'",
		"keyActualValue": "no_log is not defined",
	}
}

CxPolicy[result] {
	defaultsGroup := input.document[i].groups.defaults

    defaultsGroup.no_log == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": "defaults.no_log",
		"issueType": "IncorrectValue",
		"resourceType": "n/a",
		"resourceName": "n/a",
		"keyExpectedValue": "no_log should be set to 'true'",
		"keyActualValue": "no_log is set to 'false'",
	}
}