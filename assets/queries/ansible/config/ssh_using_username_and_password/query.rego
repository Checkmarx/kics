package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

CxPolicy[result] {
	defaultsGroup := input.document[i].groups.defaults

    common_lib.valid_key(defaultsGroup, "private_key_file")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "defaults",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "private_key_file should not be set",
		"keyActualValue": "private_key_file is set",
	}
}
