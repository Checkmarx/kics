package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	defaultsGroup := input.document[i].groups.defaults

    defaultsGroup.allow_unsafe_lookups == true

	result := {
		"documentId": input.document[i].id,
		"resourceName": "defaults",
		"resourceType": "n/a",
		"searchKey": "defaults.allow_unsafe_lookups",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "allow_unsafe_lookups should be set to 'False'",
		"keyActualValue": "allow_unsafe_lookups is set to 'True'",
	}
}
