package Cx

import data.generic.common as common_lib


CxPolicy[result] {
	groups = input.document[i].groups

	group = groups[name]
    common_lib.valid_key(group, "command_warnings")
	
	group.command_warnings == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("[%s].command_warnings", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "command_warnings should be set to True",
		"keyActualValue": "command_warnings is set to False",
	}
}
