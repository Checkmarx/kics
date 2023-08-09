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
		"keyExpectedValue": "httpapi_plugins should not be set",
		"keyActualValue": "httpapi_plugins is set",
	}
}
