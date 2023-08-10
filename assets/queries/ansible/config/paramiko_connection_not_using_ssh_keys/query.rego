package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib


CxPolicy[result] {
	paramiko := input.document[i].groups.paramiko_connection

    paramiko.look_for_keys == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": "paramiko_connection",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "look_for_keys should be defined to true",
		"keyActualValue": "look_for_keys is defined to false",
	}
}