package Cx

import data.generic.ansible as ansLib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	defaultsGroup := doc.groups.defaults

	defaultsGroup.allow_unsafe_lookups == true

	result := {
		"documentId": doc.id,
		"resourceName": "defaults",
		"resourceType": "n/a",
		"searchKey": "defaults.allow_unsafe_lookups",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "allow_unsafe_lookups should be set to 'False'",
		"keyActualValue": "allow_unsafe_lookups is set to 'True'",
	}
}
