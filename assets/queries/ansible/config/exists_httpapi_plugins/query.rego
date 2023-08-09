package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	defaultsGroup := input.document[i].groups.defaults

    common_lib.valid_key(defaultsGroup, "httpapi_plugins")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "defaults.httpapi_plugins",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "allow_unsafe_lookups should not be set",
		"keyActualValue": "allow_unsafe_lookups is set",
	}
}
