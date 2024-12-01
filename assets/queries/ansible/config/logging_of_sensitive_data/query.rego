package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	defaultsGroup := doc.groups.defaults

	not common_lib.valid_key(defaultsGroup, "no_log")

	result := {
		"documentId": doc.id,
		"searchKey": "defaults",
		"issueType": "IncorrectValue",
		"resourceType": "n/a",
		"resourceName": "n/a",
		"keyExpectedValue": "no_log should be defined and set to 'true'",
		"keyActualValue": "no_log is not defined",
	}
}

CxPolicy[result] {
	some doc in input.document
	defaultsGroup := doc.groups.defaults

	defaultsGroup.no_log == false

	result := {
		"documentId": doc.id,
		"searchKey": "defaults.no_log",
		"issueType": "IncorrectValue",
		"resourceType": "n/a",
		"resourceName": "n/a",
		"keyExpectedValue": "no_log should be set to 'true'",
		"keyActualValue": "no_log is set to 'false'",
	}
}
