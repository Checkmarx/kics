package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]
	dockerLib.check_multi_stage(name, input.document[i].command)

	not contains(resource, "healthcheck")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Dockerfile should contain instruction 'HEALTHCHECK'",
		"keyActualValue": "Dockerfile doesn't contain instruction 'HEALTHCHECK'",
	}
}

contains(cmd, elem) {
	cmd[_].Cmd = elem
}
