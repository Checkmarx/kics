package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]
	dockerLib.check_multi_stage(name, input.document[i].command)

	not name == "scratch"
	not has_user_instruction(resource)

	from_command := dockerLib.get_original_from_command(resource)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}", [from_command, name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The 'Dockerfile' should contain the 'USER' instruction",
		"keyActualValue": "The 'Dockerfile' does not contain any 'USER' instruction"
	}
}

has_user_instruction(resource) {
	
	resource[_].Cmd == "user"
}
