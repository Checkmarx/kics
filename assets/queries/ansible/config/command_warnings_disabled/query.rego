package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	groups = input.document[i].groups

	group = groups["defaults"]
    not common_lib.valid_key(group, "command_warnings")
	
	result := {
		"documentId": input.document[i].id,
		"searchKey": "[defaults].command_warnings",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "command_warnings should be defined and set to True",
		"keyActualValue": "command_warnings is not defined",
	}
}


CxPolicy[result] {
	groups = input.document[i].groups

	group = groups["defaults"]
    common_lib.valid_key(group, "command_warnings")
	
	group.command_warnings == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": "[defaults].command_warnings",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "command_warnings should be set to True",
		"keyActualValue": "command_warnings is set to False",
	}
}
