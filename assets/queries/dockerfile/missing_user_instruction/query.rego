package Cx

import data.generic.dockerfile as dockerLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.command[name]
	dockerLib.check_multi_stage(name, document.command)

	not name == "scratch"
	not has_user_instruction(resource)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "The 'Dockerfile' should contain the 'USER' instruction",
		"keyActualValue": "The 'Dockerfile' does not contain any 'USER' instruction",
	}
}

has_user_instruction(resource) {
	resource[_].Cmd == "user"
}
