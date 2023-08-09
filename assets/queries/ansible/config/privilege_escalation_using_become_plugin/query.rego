package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	defaultsGroup := input.document[i].groups.defaults

    common_lib.valid_key(defaultsGroup, "become_plugins")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "defaults.become_plugins",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "become_plugins should not be set",
		"keyActualValue": "become_plugins is set",
	}
}
