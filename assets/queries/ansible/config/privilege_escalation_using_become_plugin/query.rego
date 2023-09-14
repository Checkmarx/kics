package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	defaultsGroup := input.document[i].groups.defaults

    not common_lib.valid_key(defaultsGroup, "become")
	common_lib.valid_key(defaultsGroup, "become_user")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": "defaults.become_user",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'become' should be defined and set to 'true'",
		"keyActualValue": "'become' is not defined",
	}
}

CxPolicy[result] {
	defaultsGroup := input.document[i].groups.defaults

    defaultsGroup.become == false
	common_lib.valid_key(defaultsGroup, "become_user")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": "defaults.become",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'become' should be set to 'true'",
		"keyActualValue": "'become' is set to 'false'",
	}
}