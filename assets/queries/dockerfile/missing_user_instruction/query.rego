package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]
	dockerLib.check_multi_stage(name, input.document[i].command)

	not name == "scratch"
	not has_user_instruction(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The 'Dockerfile' should contain the 'USER' instruction",
		"keyActualValue": "The 'Dockerfile' does not contain any 'USER' instruction",
	}
}

has_user_instruction(resource) {
	resource[_].Cmd == "user"
}
